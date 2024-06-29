import Foundation
import BigInt

class Safe4DepositMethod: ContractMethod {
    
    static let methodSignature = "deposit(address,uint256)"
    
    private let owner: Address
    private let lockDay: BigUInt
    
    init(owner: Address, lockDay: BigUInt) {
        self.owner = owner
        self.lockDay = lockDay
    }

    override var methodSignature: String { Safe4DepositMethod.methodSignature }

    override var arguments: [Any] {
        [owner, lockDay]
    }
}
