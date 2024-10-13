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


class Safe4ProposalVoteMethod: ContractMethod {
        
    override var methodId: Data {
        "0xb384abef".hs.hexData ?? Data()
    }
    
    override init() {}

    override var methodSignature: String { "" }

    override var arguments: [Any] {[]}
}

class Safe4SuperNodeVoteMethod: ContractMethod {
        
    override var methodId: Data {
        "0x092c8749".hs.hexData ?? Data()
    }
    
    override init() {}

    override var methodSignature: String { "" }

    override var arguments: [Any] {[]}
}

class Safe4NodeStateUploadMethod: ContractMethod {
    
    override var methodId: Data {
        "0xa6aa19d2".hs.hexData ?? Data()
    }
    
    override init() {}

    override var methodSignature: String { "" }

    override var arguments: [Any] {[]}
}
