import Foundation
import BigInt

public class Safe4NodeVoteDecoration: TransactionDecoration {
    public let from: Address?
    public let to: Address?
    public let contract: Address?
    public let value: BigUInt

    init(from: Address?, to: Address?, contract: Address?, value: BigUInt) {
        self.from = from
        self.to = to
        self.contract = contract
        self.value = value
    }
    override public func tags() -> [TransactionTag] {
        [
            TransactionTag(type: .outgoing, protocol: .native, contractAddress: contract)
        ]
    }
}

public class Safe4NodeRegisterDecoration: TransactionDecoration {
    public let from: Address?
    public let to: Address?
    public let contract: Address?
    public let value: BigUInt

    init(from: Address?, to: Address?, contract: Address?, value: BigUInt) {
        self.from = from
        self.to = to
        self.contract = contract
        self.value = value
    }
    override public func tags() -> [TransactionTag] {
        [
            TransactionTag(type: .outgoing, protocol: .native, contractAddress: contract)
        ]
    }
}
