import Foundation
import BigInt

class Safe4WithdrawMethod: ContractMethod {
    
    static let methodSignature = "withdraw()"
    
    override init() {}

    override var methodSignature: String { Safe4WithdrawMethod.methodSignature }

    override var arguments: [Any] {[]}
}
