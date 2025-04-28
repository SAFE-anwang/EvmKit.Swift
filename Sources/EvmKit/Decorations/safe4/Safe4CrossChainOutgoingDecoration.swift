import BigInt

public class Safe4CrossChainOutgoingDecoration: TransactionDecoration {
    public let from: Address
    public let to: Address
    public let value: BigUInt

    init(from: Address, to: Address, value: BigUInt) {
        self.from = from
        self.to = to
        self.value = value
    }

    override public func tags() -> [TransactionTag] {
        let tags = [
            TransactionTag(type: .outgoing, protocol: .native, addresses: [to.hex]),
        ]
        return tags
    }
}
