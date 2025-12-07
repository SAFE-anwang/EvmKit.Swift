import Foundation
import web3swift
import Web3Core
import BigInt

class Safe4Provider {
    private let urls: [URL]
    private let chain: Chain
    
    init(chain: Chain, urls: [URL]) {
        self.chain = chain
        self.urls = urls
    }
    
    private func web3Instance(urlIndex: Int = 0) async throws -> Web3 {
        do {
            return try await Web3.new( urls[urlIndex], network: Networks.Custom(networkID: BigUInt(chain.id)))
        } catch {
            let nextIndex = urlIndex + 1
            if nextIndex < urls.count {
                return try await web3Instance(urlIndex:nextIndex)
            } else {
                throw error
            }
        }
    }
    
    func getLockedAmount(type: AccountManager.ContractType, address: Address) async throws -> BigUInt {
        let web3 = try await web3Instance()
        return try await web3.safe4.accountmanager(type: type).getTotalAmount( Web3Core.EthereumAddress(address.hex)!).amount
    }
    
    func deposit(privateKey: Data, value: BigUInt, to: Address, lockDay: BigUInt) async throws -> String {
        let web3 = try await web3Instance()
        let to = Web3Core.EthereumAddress(to.hex)!
        return try await web3.safe4.accountmanager.deposit(privateKey: privateKey, value: value, to: to, lockDay: lockDay)
    }
    
    func sendSafe4LineLock(type: AccountManager.ContractType, privateKey: Data, value: BigUInt, to: Address, times: BigUInt, spaceDay: BigUInt, startDay: BigUInt) async throws -> String {
        let web3 = try await web3Instance()
        let to = Web3Core.EthereumAddress(to.hex)!
        return try await web3.safe4.accountmanager(type: type).batchDeposit4One(privateKey: privateKey, value: value, to: to, times: times, spaceDay: spaceDay, startDay: startDay)
    }
    
    func withdraw(type: AccountManager.ContractType, privateKey: Data) {
        Task {
            do {
                let web3 = try await web3Instance()
                let hashHexString = try await web3.safe4.accountmanager(type: type).withdraw(privateKey: privateKey)
            }catch {
                print("Safe4 withdraw Error: \(error)")
            }
        }
    }
}

// src20
extension Safe4Provider {
    var SRC20LockContract: String {
        if (chain == .SafeFourTestNet) {
            "0x4f203092FB68732D8484c099a72dDc5a195f26f9"
        } else {
            "0x6A6dFAF83cc1741FE08A9EFDea596dEad68f7420"
        }
    }

    func src20TimeLock(privateKey: Data, token: Address, to: Address, amount: BigUInt, lockDay: BigUInt) async throws -> String {
        let web3 = try await web3Instance()
        let to = Web3Core.EthereumAddress(to.hex)!
        let tokenAddress = Web3Core.EthereumAddress(token.hex)!
        return try await SRC20LockFactory(web3: web3, contractAddr: SRC20LockContract).lock(privateKey: privateKey, token: tokenAddress, to: to, amount: amount, lockDay: lockDay)
    }
}
