import BigInt
import UIKit

open class UnknownTransactionDecoration: TransactionDecoration {
    private let userAddress: Address
    private let toAddress: Address?
    public let fromAddress: Address?
    private let value: BigUInt?

    public let internalTransactions: [InternalTransaction]
    public let eventInstances: [ContractEventInstance]

    public init(userAddress: Address, fromAddress: Address?, toAddress: Address?, value: BigUInt?, internalTransactions: [InternalTransaction], eventInstances: [ContractEventInstance]) {
        self.userAddress = userAddress
        self.fromAddress = fromAddress
        self.toAddress = toAddress
        self.value = value
        self.internalTransactions = internalTransactions
        self.eventInstances = eventInstances
    }

    override public func tags() -> [TransactionTag] {
        Array(Set(tagsFromInternalTransactions + tagsFromEventInstances))
    }

    private var tagsFromInternalTransactions: [TransactionTag] {
        let value = value ?? 0
        let incomingInternalTransactions = internalTransactions.filter { $0.to == userAddress }

        var outgoingValue: BigUInt = 0
        if fromAddress == userAddress {
            outgoingValue = value
        }
        var incomingValue: BigUInt = 0
        if toAddress == userAddress {
            incomingValue = value
        }
        for incomingInternalTransaction in incomingInternalTransactions {
            incomingValue += incomingInternalTransaction.value
        }
        
        var tags = [TransactionTag]()
        if let to = toAddress?.eip55.lowercased(), Safe4Contract.allCases.map({$0.rawValue.lowercased()}).contains(to) {
            let addresses = [fromAddress, toAddress]
                .compactMap { $0 }
                .filter { $0 != userAddress }
                .map(\.hex)
            tags.append(TransactionTag(type: .outgoing, protocol: .native, addresses: addresses))
            return tags
        }
        if let contracts = Safe4CustomTokenManager.safe4DeployContracts(),
           let to = toAddress?.hex.lowercased(), contracts.contains(to) {
            tags.append(TransactionTag(type: .incoming, protocol: .eip20, contractAddress: toAddress))
            return tags
        }
        
        // if has value or has internalTxs must add Evm tag
        if outgoingValue == 0, incomingValue == 0 {
            return []
        }

        var addresses = [fromAddress, toAddress]
            .compactMap { $0 }
            .filter { $0 != userAddress }
            .map(\.hex)

        if incomingValue > outgoingValue {
            tags.append(TransactionTag(type: .incoming, protocol: .native, addresses: addresses))
        } else if outgoingValue > incomingValue {
            tags.append(TransactionTag(type: .outgoing, protocol: .native, addresses: addresses))
        }

        return tags
    }

    private var tagsFromEventInstances: [TransactionTag] {
        var tags = [TransactionTag]()

        for eventInstance in eventInstances {
            tags.append(contentsOf: eventInstance.tags(userAddress: userAddress))
        }

        return tags
    }
}
