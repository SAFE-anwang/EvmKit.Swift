import BigInt
import Foundation
import HsExtensions
import HsToolKit
import web3swift
import Web3Core

class RpcBlockchainSafe4 {
    private var tasks = Set<AnyTask>()

    weak var delegate: IBlockchainDelegate?

    private let address: Address
    private let storage: IApiStorage
    private let syncer: IRpcSyncer
    private let transactionBuilder: Safe4TransactionBuilder
    private var logger: Logger?
    private let urls: [URL]
    private let chain: Chain
    
    private(set) var syncState: SyncState = .notSynced(error: Kit.SyncError.notStarted) {
        didSet {
            if syncState != oldValue {
                delegate?.onUpdate(syncState: syncState)
            }
        }
    }

    private var synced = false

    init(address: Address, storage: IApiStorage, syncer: IRpcSyncer, transactionBuilder: Safe4TransactionBuilder, urls: [URL], chain: Chain, logger: Logger? = nil) {
        self.address = address
        self.storage = storage
        self.syncer = syncer
        self.transactionBuilder = transactionBuilder
        self.logger = logger
        self.urls = urls
        self.chain = chain
    }

    private func syncLastBlockHeight() {
        Task { [weak self] in
            let web3 = try await self?.web3Instance()
            let lastBlockHeight = try await web3!.eth.blockNumber()
            self?.onUpdate(lastBlockHeight: Int(lastBlockHeight))
        }.store(in: &tasks)
    }

    private func onUpdate(lastBlockHeight: Int) {
        storage.save(lastBlockHeight: lastBlockHeight)
        delegate?.onUpdate(lastBlockHeight: lastBlockHeight)
    }

    func onUpdate(accountState: AccountState) {
        storage.save(accountState: accountState)
        delegate?.onUpdate(accountState: accountState)
    }
}

extension RpcBlockchainSafe4: IRpcSyncerDelegate {
    func didUpdate(state: SyncerState) {
        switch state {
        case .preparing:
            syncState = .syncing(progress: nil)
        case .ready:
            syncState = .syncing(progress: nil)
            syncAccountState()
            syncLastBlockHeight()
        case let .notReady(error):
            tasks = Set()
            syncState = .notSynced(error: error)
        }
    }

    func didUpdate(lastBlockHeight: Int) {
        onUpdate(lastBlockHeight: lastBlockHeight)
        // report to whom???
    }
}

extension RpcBlockchainSafe4: IBlockchain {
    var source: String {
        "RPC \(syncer.source)"
    }

    func start() {
        syncState = .syncing(progress: nil)
        syncer.start()
    }

    func stop() {
        syncer.stop()
    }

    func refresh() {
        switch syncer.state {
        case .preparing:
            ()
        case .ready:
            syncAccountState()
            syncLastBlockHeight()
        case .notReady:
            syncer.start()
        }
    }

    func syncAccountState() {
        Task { [weak self, syncer, address] in
            do {
                
                async let balance = try syncer.fetch(rpc: GetBalanceJsonRpc(address: address, defaultBlockParameter: .latest))
                async let nonce = try syncer.fetch(rpc: GetTransactionCountJsonRpc(address: address, defaultBlockParameter: .latest))
                let web3 = try await self?.web3Instance()
                async let lockedAmount = try web3!.safe4.accountmanager.getLockedAmount( Web3Core.EthereumAddress(address.hex)!).amount
                let accountState = try await AccountState(balance: balance, nonce: nonce, timeLockBalance: lockedAmount)
                self?.onUpdate(accountState: accountState)
                self?.syncState = .synced
            } catch {
                if let webSocketError = error as? WebSocketStateError {
                    switch webSocketError {
                    case .connecting:
                        self?.syncState = .syncing(progress: nil)
                    case .couldNotConnect:
                        self?.syncState = .notSynced(error: webSocketError)
                    }
                } else {
                    self?.syncState = .notSynced(error: error)
                }
            }
        }.store(in: &tasks)
    }
    
    private func web3Instance(urlIndex: Int = 0) async throws -> Web3 {
        do {
            return try await Web3.new( urls[urlIndex], network: Networks.Custom(networkID: BigUInt(chain.id)))
        } catch {
            let nextIndex = urlIndex + 1
            if nextIndex < urls.count {
                return try await  web3Instance(urlIndex:nextIndex)
            } else {
                throw error
            }
        }
    }

    var lastBlockHeight: Int? {
        storage.lastBlockHeight
    }

    var accountState: AccountState? {
        storage.accountState
    }

    func nonce(defaultBlockParameter: DefaultBlockParameter) async throws -> Int {
        try await syncer.fetch(rpc: GetTransactionCountJsonRpc(address: address, defaultBlockParameter: defaultBlockParameter))
    }

    func send(rawTransaction: RawTransaction, signature: Signature, privateKey: Data, lockDay: Int? = nil) async throws -> Transaction {
        let web3 = try await web3Instance()
        if let days = lockDay {
            let to = Web3Core.EthereumAddress(rawTransaction.to.hex)!
            let hash = try await web3.safe4.accountmanager.deposit(privateKey: privateKey, value: rawTransaction.value, to: to, lockDay: BigUInt(days))
            return try transactionBuilder.transactionDeposit(rawTransaction: rawTransaction, signature: signature, lockDay: days, hash: hash.hs.hexData ?? Data())
        }else {
            let encoded = transactionBuilder.encode(rawTransaction: rawTransaction, signature: signature)
            _ = try await syncer.fetch(rpc: SendRawTransactionJsonRpc(signedTransaction: encoded))
            return transactionBuilder.transaction(rawTransaction: rawTransaction, signature: signature)
        }
    }

    func transactionReceipt(transactionHash: Data) async throws -> RpcTransactionReceipt {
        try await syncer.fetch(rpc: GetTransactionReceiptJsonRpc(transactionHash: transactionHash))
    }

    func transaction(transactionHash: Data) async throws -> RpcTransaction {
        try await syncer.fetch(rpc: GetTransactionByHashJsonRpc(transactionHash: transactionHash))
    }

    func getStorageAt(contractAddress: Address, positionData: Data, defaultBlockParameter: DefaultBlockParameter) async throws -> Data {
        try await syncer.fetch(rpc: GetStorageAtJsonRpc(contractAddress: contractAddress, positionData: positionData, defaultBlockParameter: defaultBlockParameter))
    }

    func call(contractAddress: Address, data: Data, defaultBlockParameter: DefaultBlockParameter) async throws -> Data {
        try await syncer.fetch(rpc: Self.callRpc(contractAddress: contractAddress, data: data, defaultBlockParameter: defaultBlockParameter))
    }

    func estimateGas(to: Address?, amount: BigUInt?, gasLimit: Int?, gasPrice: GasPrice, data: Data?) async throws -> Int {
        try await syncer.fetch(rpc: EstimateGasJsonRpc(from: address, to: to, amount: amount, gasLimit: gasLimit, gasPrice: gasPrice, data: data))
    }

    func getBlock(blockNumber: Int) async throws -> RpcBlock {
        try await syncer.fetch(rpc: GetBlockByNumberJsonRpc(number: blockNumber))
    }

    func fetch<T>(rpcRequest: JsonRpc<T>) async throws -> T {
        try await syncer.fetch(rpc: rpcRequest)
    }
}

extension RpcBlockchainSafe4 {
    static func callRpc(contractAddress: Address, data: Data, defaultBlockParameter: DefaultBlockParameter) -> JsonRpc<Data> {
        CallJsonRpc(contractAddress: contractAddress, data: data, defaultBlockParameter: defaultBlockParameter)
    }
}

extension RpcBlockchainSafe4 {
    static func instance(address: Address, storage: IApiStorage, syncer: IRpcSyncer, transactionBuilder: Safe4TransactionBuilder, urls: [URL], chain: Chain, logger: Logger? = nil) -> RpcBlockchainSafe4 {
        let blockchain = RpcBlockchainSafe4(address: address, storage: storage, syncer: syncer, transactionBuilder: transactionBuilder, urls: urls, chain: chain, logger: logger)
        syncer.delegate = blockchain
        return blockchain
    }

    static func estimateGas(networkManager: NetworkManager, rpcSource: RpcSource, from: Address, to: Address?, amount: BigUInt?, gasLimit: Int, gasPrice: GasPrice, data: Data?) async throws -> Int {
        guard case let .http(urls, auth) = rpcSource else {
            throw Kit.RpcSourceError.websocketNotSupported
        }

        let provider = NodeApiProvider(networkManager: networkManager, urls: urls, auth: auth)
        let rpcRequest = EstimateGasJsonRpc(from: from, to: to, amount: amount, gasLimit: gasLimit, gasPrice: gasPrice, data: data)
        return try await provider.fetch(rpc: rpcRequest)
    }

    static func call<T>(networkManager: NetworkManager, rpcSource: RpcSource, rpcRequest: JsonRpc<T>) async throws -> T {
        guard case let .http(urls, auth) = rpcSource else {
            throw Kit.RpcSourceError.websocketNotSupported
        }

        let provider = NodeApiProvider(networkManager: networkManager, urls: urls, auth: auth)
        return try await provider.fetch(rpc: rpcRequest)
    }
}

