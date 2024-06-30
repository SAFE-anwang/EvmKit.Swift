import BigInt
import Combine
import EvmKit
import Foundation

class EthereumAdapter {
    private let evmKit: Kit
    private let signer: Signer?
    private let decimal = 18

    init(evmKit: Kit, signer: Signer?) async {
        self.evmKit = evmKit
        self.signer = signer
        
        if evmKit.chain == .SafeFour, let signer {
            evmKit.withdraw(privateKey: signer.privateKey)
        }
    }

    private func transactionRecord(fullTransaction: FullTransaction) -> TransactionRecord {
        let transaction = fullTransaction.transaction

        var amount: Decimal?

        if let value = transaction.value, let significand = Decimal(string: value.description) {
            amount = Decimal(sign: .plus, exponent: -decimal, significand: significand)
        }

        return TransactionRecord(
            transactionHash: transaction.hash.hs.hexString,
            transactionHashData: transaction.hash,
            timestamp: transaction.timestamp,
            isFailed: transaction.isFailed,
            from: transaction.from,
            to: transaction.to,
            amount: amount,
            input: transaction.input.map(\.hs.hexString),
            blockHeight: transaction.blockNumber,
            transactionIndex: transaction.transactionIndex,
            decoration: String(describing: fullTransaction.decoration)
        )
    }
}

extension EthereumAdapter {
    func start() {
        evmKit.start()
    }

    func stop() {
        evmKit.stop()
    }

    func refresh() {
        evmKit.refresh()
    }

    var name: String {
        "safe4"
    }

    var coin: String {
        "SAFE4"
    }

    var lastBlockHeight: Int? {
        evmKit.lastBlockHeight
    }

    var syncState: SyncState {
        evmKit.syncState
    }

    var transactionsSyncState: SyncState {
        evmKit.transactionsSyncState
    }

    var balance: Decimal {
        if let balance = evmKit.accountState?.balance, let significand = Decimal(string: balance.description) {
            return Decimal(sign: .plus, exponent: -decimal, significand: significand)
        }

        return 0
    }

    var receiveAddress: Address {
        evmKit.receiveAddress
    }

    var lastBlockHeightPublisher: AnyPublisher<Void, Never> {
        evmKit.lastBlockHeightPublisher.map { _ in () }.eraseToAnyPublisher()
    }

    var syncStatePublisher: AnyPublisher<Void, Never> {
        evmKit.syncStatePublisher.map { _ in () }.eraseToAnyPublisher()
    }

    var transactionsSyncStatePublisher: AnyPublisher<Void, Never> {
        evmKit.transactionsSyncStatePublisher.map { _ in () }.eraseToAnyPublisher()
    }

    var balancePublisher: AnyPublisher<Void, Never> {
        evmKit.accountStatePublisher.map { _ in () }.eraseToAnyPublisher()
    }

    var transactionsPublisher: AnyPublisher<Void, Never> {
        evmKit.transactionsPublisher(tagQueries: []).map { _ in () }.eraseToAnyPublisher()
    }

    func transactions(from hash: Data?, limit: Int?) -> [TransactionRecord] {
        evmKit.transactions(tagQueries: [], fromHash: hash, limit: limit).compactMap { transactionRecord(fullTransaction: $0) }
    }

    func transaction(hash: Data, interTransactionIndex _: Int) -> TransactionRecord? {
        evmKit.transaction(hash: hash).map { transactionRecord(fullTransaction: $0) }
    }

    func estimatedGasLimit(to address: Address, value: Decimal, gasPrice: GasPrice) async throws -> Int {
        let value = BigUInt(value.hs.roundedString(decimal: decimal))!
        return try await evmKit.fetchEstimateGas(to: address, amount: value, gasPrice: gasPrice)
    }

    func transaction(hash: Data) async throws -> FullTransaction {
        try await evmKit.fetchTransaction(hash: hash)
    }

    func send(to: Address, amount: Decimal, gasLimit: Int, gasPrice: GasPrice) async throws {
        guard let signer else {
            throw SendError.noSigner
        }

        let amount = BigUInt(amount.hs.roundedString(decimal: decimal))!
        let transactionData = evmKit.transferTransactionData(to: to, value: amount)

        let rawTransaction = try await evmKit.fetchRawTransaction(transactionData: transactionData, gasPrice: gasPrice, gasLimit: gasLimit)
        let signature = try signer.signature(rawTransaction: rawTransaction)

        _ = try await evmKit.send(rawTransaction: rawTransaction, signature: signature, privateKey: signer.privateKey)
    }
    
    func sendLock(to: Address, amount: Decimal, gasLimit: Int, gasPrice: GasPrice, lockDay: Int) async throws {
        guard let signer else {
            throw SendError.noSigner
        }
        let amount = BigUInt(amount.hs.roundedString(decimal: decimal))!
        var transactionData = evmKit.transferTransactionData(to: to, value: amount)
        transactionData.update(lockTime: lockDay)
        let rawTransaction = try await evmKit.safe4LockRawTransaction(transactionData: transactionData, gasPrice: gasPrice, gasLimit: gasLimit, lockDay: lockDay)
        let signature = try signer.signature(rawTransaction: rawTransaction)

        _ = try await evmKit.send(rawTransaction: rawTransaction, signature: signature, privateKey: signer.privateKey, lockDay: lockDay)
    }
}

extension EthereumAdapter {
    enum SendError: Error {
        case noSigner
    }
}
