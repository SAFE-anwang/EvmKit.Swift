import Foundation
import BigInt

public class Safe4BatchRedeemDecoration: TransactionDecoration {
    public let from: Address?
    public let to: Address?
    public let value: BigUInt

    init(from: Address?, to: Address?, value: BigUInt) {
        self.from = from
        self.to = to
        self.value = value
    }
    override public func tags() -> [TransactionTag] {
        [
            TransactionTag(type: .outgoing, protocol: .native)
        ]
    }
}
