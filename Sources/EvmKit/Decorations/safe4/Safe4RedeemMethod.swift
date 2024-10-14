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
    static let methodId: Data = "0xb384abef".hs.hexData ?? Data()

    override var methodId: Data {
        Self.methodId
    }
    
    let isVote: BigUInt
    let dstAddr: Address
    
    init(isVote: BigUInt, dstAddr: Address) {
        self.isVote = isVote
        self.dstAddr = dstAddr
    }

    override var methodSignature: String { "" }

    override var arguments: [Any] {[isVote, dstAddr]}
}

class Safe4SuperNodeVoteMethod: ContractMethod {
    static let methodId: Data = "0x092c8749".hs.hexData ?? Data()
    
    override var methodId: Data {
        Self.methodId
    }
    
    let isVote: BigUInt
    let dstAddr: Address
    
    init(isVote: BigUInt, dstAddr: Address) {
        self.isVote = isVote
        self.dstAddr = dstAddr
    }

    override var methodSignature: String { "" }

    override var arguments: [Any] {[isVote, dstAddr]}
}

class Safe4SuperNodeLockVoteMethod: ContractMethod {
    static let methodId: Data = "0x03c4c7f3".hs.hexData ?? Data()

    override var methodId: Data {
        Self.methodId
    }
    
    let isVote: BigUInt
    let dstAddr: Address
    
    init(isVote: BigUInt, dstAddr: Address) {
        self.isVote = isVote
        self.dstAddr = dstAddr
    }

    override var methodSignature: String { "" }

    override var arguments: [Any] {[isVote, dstAddr]}
}

class Safe4NodeStateUploadMethod: ContractMethod {
    
    override var methodId: Data {
        "0xa6aa19d2".hs.hexData ?? Data()
    }
    
    override init() {}

    override var methodSignature: String { "" }

    override var arguments: [Any] {[]}
}

class Safe4NodeDeployMethod: ContractMethod {
    static let methodId: Data = "0x60806040".hs.hexData ?? Data()

    override var methodId: Data {
        Self.methodId
    }
    
    override init() {}

    override var methodSignature: String { "" }

    override var arguments: [Any] {[]}
}
