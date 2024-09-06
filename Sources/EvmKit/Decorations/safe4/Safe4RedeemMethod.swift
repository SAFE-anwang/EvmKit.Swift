import Foundation
import BigInt

class Safe4RedeemAvailableMethod: ContractMethod {
    
    override var methodId: Data {
        "0x8e5cd5ec".hs.hexData ?? Data()
    }
    override init() {}

    override var methodSignature: String { "" }

    override var arguments: [Any] {[]}
}

class Safe4RedeemLockedMethod: ContractMethod {
    
    override var methodId: Data {
        "0xd885085f".hs.hexData ?? Data()
    }
    override init() {}

    override var methodSignature: String { "" }

    override var arguments: [Any] {[]}
}

class Safe4RedeemMasterNodeMethod: ContractMethod {
        
    override var methodId: Data {
        "0xe70c2626".hs.hexData ?? Data()
    }
    
    override init() {}

    override var methodSignature: String { "" }

    override var arguments: [Any] {[]}
}


