import Foundation
import BigInt

public class Safe4WithdrawDecoration: TransactionDecoration {
    public let from: Address
    public let value: BigUInt

    init(from: Address, value: BigUInt) {
        self.from = from
        self.value = value
    }

    override public func tags() -> [TransactionTag] {
        [
            TransactionTag(type: .incoming, protocol: .native, addresses: [from.hex])
        ]
    }
}
