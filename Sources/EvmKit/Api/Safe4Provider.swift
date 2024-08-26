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
    
    func getLockedAmount(address: Address) async throws -> BigUInt {
        let web3 = try await web3Instance()
        return try await web3.safe4.accountmanager.getTotalAmount( Web3Core.EthereumAddress(address.hex)!).amount
    }
    
    func deposit(privateKey: Data, value: BigUInt, to: Address, lockDay: BigUInt) async throws -> String {
        let web3 = try await web3Instance()
        let to = Web3Core.EthereumAddress(to.hex)!
        return try await web3.safe4.accountmanager.deposit(privateKey: privateKey, value: value, to: to, lockDay: lockDay)
    }
    
    func withdraw(privateKey: Data) {
        Task {
            do {
                let web3 = try await web3Instance()
                let hashHexString = try await web3.safe4.accountmanager.withdraw(privateKey: privateKey)
            }catch {
                print("Safe4 withdraw Error: \(error)")
            }
        }

    }
}
