import Foundation
import BigInt
import HsCryptoKit
import web3swift
import Web3Core

class Safe4TransactionBuilder {
    let chainId: Int
    private let address: Address

    init(chain: Chain, address: Address) {
        chainId = chain.id
        self.address = address
    }

    func transaction(rawTransaction: RawTransaction, signature: Signature, hash: Data? = nil) -> Transaction {
        let transactionHash = hash != nil ? hash! : Crypto.sha3(encode(rawTransaction: rawTransaction, signature: signature))

        var maxFeePerGas: Int?
        var maxPriorityFeePerGas: Int?
        if case let .eip1559(max, priority) = rawTransaction.gasPrice {
            maxFeePerGas = max
            maxPriorityFeePerGas = priority
        }

        return Transaction(
            hash: transactionHash,
            timestamp: Int(Date().timeIntervalSince1970),
            isFailed: false,
            from: address,
            to: rawTransaction.to,
            value: rawTransaction.value,
            input: rawTransaction.data,
            nonce: rawTransaction.nonce,
            gasPrice: rawTransaction.gasPrice.max,
            maxFeePerGas: maxFeePerGas,
            maxPriorityFeePerGas: maxPriorityFeePerGas,
            gasLimit: rawTransaction.gasLimit
        )
    }

    func encode(rawTransaction: RawTransaction, signature: Signature?) -> Data {
        Self.encode(rawTransaction: rawTransaction, signature: signature, chainId: chainId)
    }
}

extension Safe4TransactionBuilder {
    static func encode(rawTransaction: RawTransaction, signature: Signature?, chainId: Int = 1) -> Data {
        let signatureArray: [Any?] = [
            signature?.v,
            signature?.r,
            signature?.s,
        ].compactMap { $0 }

        switch rawTransaction.gasPrice {
        case let .legacy(legacyGasPrice):
            let encoded = RLP.encode([
                rawTransaction.nonce,
                legacyGasPrice,
                rawTransaction.gasLimit,
                rawTransaction.to.raw,
                rawTransaction.value,
                rawTransaction.data,
            ] + signatureArray)

            return encoded
        case let .eip1559(maxFeePerGas, maxPriorityFeePerGas):
            let encodedTransaction = RLP.encode([
                chainId,
                rawTransaction.nonce,
                maxPriorityFeePerGas,
                maxFeePerGas,
                rawTransaction.gasLimit,
                rawTransaction.to.raw,
                rawTransaction.value,
                rawTransaction.data,
                [],
            ] + signatureArray)

            return Data([0x02]) + encodedTransaction
        }
    }
}

extension Safe4TransactionBuilder {
    
    func transactionDeposit(rawTransaction: RawTransaction, signature: Signature, lockDay: Int, hash: Data) throws -> Transaction {
        let input = Safe4DepositMethod(owner: rawTransaction.to, lockDay: BigUInt(lockDay)).encodedABI()
        let to = try! Address(hex: Safe4ContractAddress.AccountManagerContractAddr)
        
        var maxFeePerGas: Int?
        var maxPriorityFeePerGas: Int?
        if case let .eip1559(max, priority) = rawTransaction.gasPrice {
            maxFeePerGas = max
            maxPriorityFeePerGas = priority
        }

        return Transaction(
            hash: hash,
            timestamp: Int(Date().timeIntervalSince1970),
            isFailed: false,
            from: address,
            to: to,
            value: rawTransaction.value,
            input: input,
            nonce: rawTransaction.nonce,
            gasPrice: rawTransaction.gasPrice.max,
            maxFeePerGas: maxFeePerGas,
            maxPriorityFeePerGas: maxPriorityFeePerGas,
            gasLimit: rawTransaction.gasLimit,
            lockDay: lockDay
        )
    }
}
