import BigInt
import Foundation

public struct TransactionData {
    public var to: Address
    public var value: BigUInt
    public var input: Data
    public var lockTime: Int?
    public var isBothErc: Bool = false
    public var safe4Swap: Int = 0
    
    public init(to: Address, value: BigUInt, input: Data, lockTime: Int? = nil, isBothErc: Bool = false, safe4Swap: Int = 0) {
        self.to = to
        self.value = value
        self.input = input
        self.lockTime = lockTime
        self.isBothErc = isBothErc
        self.safe4Swap = safe4Swap
    }
    
    mutating public func update(lockTime: Int?) {
        self.lockTime = lockTime
    }
}

extension TransactionData: Equatable {
    public static func == (lhs: TransactionData, rhs: TransactionData) -> Bool {
        lhs.to == rhs.to && lhs.value == rhs.value && lhs.input == rhs.input && lhs.lockTime == rhs.lockTime && lhs.isBothErc == rhs.isBothErc && lhs.safe4Swap == rhs.safe4Swap
    }
}
