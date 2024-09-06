import Foundation
import BigInt

class Safe4RedeemAvailableMethod: ContractMethod {
    
    static let methodSignature = "RedeemAvailable(string,uint256,address)"
    
    override init() {}

    override var methodSignature: String { Safe4RedeemAvailableMethod.methodSignature }

    override var arguments: [Any] {[]}
}

class Safe4RedeemLockedMethod: ContractMethod {
    
    static let methodSignature = "RedeemLocked(string,uint256, address,uint256)"
    
    override init() {}

    override var methodSignature: String { Safe4RedeemLockedMethod.methodSignature }

    override var arguments: [Any] {[]}
}

class Safe4RedeemMasterNodeMethod: ContractMethod {
    
    static let methodSignature = "RedeemMasterNode(string,address,uint256)"
    
    override init() {}

    override var methodSignature: String { Safe4RedeemMasterNodeMethod.methodSignature }

    override var arguments: [Any] {[]}
}


