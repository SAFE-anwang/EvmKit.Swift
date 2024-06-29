import BigInt
import Foundation

public struct TransactionData {
    public var to: Address
    public var value: BigUInt
    public var input: Data
    public var lockTime: Int?
    
    public init(to: Address, value: BigUInt, input: Data, lockTime: Int? = nil) {
        self.to = to
        self.value = value
        self.input = input
        self.lockTime = lockTime
    }
    
    mutating public func update(lockTime: Int?) {
        self.lockTime = lockTime
    }
}

extension TransactionData: Equatable {
    public static func == (lhs: TransactionData, rhs: TransactionData) -> Bool {
        lhs.to == rhs.to && lhs.value == rhs.value && lhs.input == rhs.input && lhs.lockTime == rhs.lockTime
    }
}
