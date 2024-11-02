import Foundation
import BigInt

class Safe4WithdrawMethod: ContractMethod {
        
    override var methodId: Data {
        Safe4Methods.Withdraw.id.hs.hexData ?? Data()
    }
    override init() {}

    override var methodSignature: String { "" }

    override var arguments: [Any] {[]}
}

class Safe4RedeemAvailableMethod: ContractMethod {
    
    override var methodId: Data {
        Safe4Methods.RedeemAvailable.id.hs.hexData ?? Data()
    }
    override init() {}

    override var methodSignature: String { "" }

    override var arguments: [Any] {[]}
}

class Safe4RedeemLockedMethod: ContractMethod {
    
    override var methodId: Data {
        Safe4Methods.RedeemLocked.id.hs.hexData ?? Data()
    }
    override init() {}

    override var methodSignature: String { "" }

    override var arguments: [Any] {[]}
}

class Safe4RedeemMasterNodeMethod: ContractMethod {
        
    override var methodId: Data {
        Safe4Methods.RedeemMsaternode.id.hs.hexData ?? Data()
    }
    
    override init() {}

    override var methodSignature: String { "" }

    override var arguments: [Any] {[]}
}


class Safe4ProposalVoteMethod: ContractMethod {
    static let methodId: Data = Safe4Methods.ProposalVote.id.hs.hexData ?? Data()

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
    static let methodId: Data = Safe4Methods.VoteSuperNode.id.hs.hexData ?? Data()
    
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
    static let methodId: Data = Safe4Methods.LockVote.id.hs.hexData ?? Data()

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
    
    static let methodId: Data = Safe4Methods.NodeStateUpload.id.hs.hexData ?? Data()
    
    override var methodId: Data {
        Self.methodId
    }
    override init() {}

    override var methodSignature: String { "" }

    override var arguments: [Any] {[]}
}

class Safe4NodeDeployMethod: ContractMethod {
    static let methodId: Data = Safe4Methods.ContractDeployment.id.hs.hexData ?? Data()

    override var methodId: Data {
        Self.methodId
    }
    
    override init() {}

    override var methodSignature: String { "" }

    override var arguments: [Any] {[]}
}

class Safe4UpdateDescMethod: ContractMethod {
    static let methodId: Data = Safe4Methods.NodeUpdateDesc.id.hs.hexData ?? Data()

    override var methodId: Data {
        Self.methodId
    }
    
    override init() {}

    override var methodSignature: String { "" }

    override var arguments: [Any] {[]}
}

class Safe4NodeUpdateEnodeMethod: ContractMethod {
    static let methodId: Data = Safe4Methods.NodeUpdateEnode.id.hs.hexData ?? Data()

    override var methodId: Data {
        Self.methodId
    }
    
    override init() {}

    override var methodSignature: String { "" }

    override var arguments: [Any] {[]}
}

class Safe4NodeUpdateNameMethod: ContractMethod {
    static let methodId: Data = Safe4Methods.NodeUpdateName.id.hs.hexData ?? Data()

    override var methodId: Data {
        Self.methodId
    }
    
    override init() {}

    override var methodSignature: String { "" }

    override var arguments: [Any] {[]}
}

class Safe4NodeUpdateAddressMethod: ContractMethod {
    static let methodId: Data = Safe4Methods.NodeUpdateAddress.id.hs.hexData ?? Data()

    override var methodId: Data {
        Self.methodId
    }
    
    override init() {}

    override var methodSignature: String { "" }

    override var arguments: [Any] {[]}
}

class Safe4AppendRegisterMethod: ContractMethod {
    static let methodId: Data = Safe4Methods.AppendRegister.id.hs.hexData ?? Data()
    
    override var methodId: Data {
        Self.methodId
    }
    
    let addr: Address
    let lockDay: BigUInt
    
    init(addr: Address, lockDay: BigUInt) {
        self.addr = addr
        self.lockDay = lockDay
    }
    
    override var methodSignature: String { "" }
    
    override var arguments: [Any] {[addr, lockDay]}
}

class Safe4MasterNodeRegisterMethod: ContractMethod {
    static let methodId: Data = Safe4Methods.MasterNodeRegister.id.hs.hexData ?? Data()

    override var methodId: Data {
        Self.methodId
    }
    
    let isUnion: BigUInt
    let addr: Address
    let lockDay: BigUInt

    init(isUnion: BigUInt, addr: Address, lockDay: BigUInt) {
        self.isUnion = isUnion
        self.addr = addr
        self.lockDay = lockDay
    }

    override var methodSignature: String { "" }

    override var arguments: [Any] {[isUnion, addr, lockDay]}
}

class Safe4SuperNodeRegisterMethod: ContractMethod {
    static let methodId: Data = Safe4Methods.SuperNodeRegister.id.hs.hexData ?? Data()

    override var methodId: Data {
        Self.methodId
    }
    
    let isUnion: BigUInt
    let addr: Address
    let lockDay: BigUInt

    init(isUnion: BigUInt, addr: Address, lockDay: BigUInt) {
        self.isUnion = isUnion
        self.addr = addr
        self.lockDay = lockDay
    }

    override var methodSignature: String { "" }

    override var arguments: [Any] {[isUnion, addr, lockDay]}
}

class Safe4AddLockDayMethod: ContractMethod {
    static let methodId: Data = Safe4Methods.AddLockDay.id.hs.hexData ?? Data()

    override var methodId: Data {
        Self.methodId
    }
    
    let lockId: BigUInt
    let lockDay: BigUInt

    init(lockId: BigUInt, lockDay: BigUInt) {
        self.lockId = lockId
        self.lockDay = lockDay
    }

    override var methodSignature: String { "" }

    override var arguments: [Any] {[lockId, lockDay]}
}


public enum Safe4Methods: CaseIterable {
    case AppendRegister
    case Withdraw
    case WithdrawByID
    case CreateProposal
    case VoteSuperNode
    case MasterNodeRegister
    case SuperNodeRegister
    case NodeUpdateDesc
    case NodeUpdateEnode
    case NodeUpdateName
    case NodeUpdateAddress
    case LockVote
    case Reward
    case RedeemMsaternode
    case RedeemLocked
    case RedeemAvailable
    case NodeStateUpload
    case ProposalVote
    case ContractDeployment
    case AddLockDay
    
    public var id: String {
        switch self {
        case .AppendRegister: "0x978a11d1"
        case .Withdraw: "0x3ccfd60b"
        case .WithdrawByID: "0xc28423ec"
        case .CreateProposal: "0xc54256ed"
        case .VoteSuperNode: "0x092c8749"
        case .MasterNodeRegister: "0x082ed4d5"
        case .SuperNodeRegister: "0xa57afda4"
        case .NodeUpdateDesc: "0x1ed6f423"
        case .NodeUpdateEnode: "0x7255acae"
        case .NodeUpdateName: "0x45ca25ed"
        case .NodeUpdateAddress: "0xefe08a7d"
        case .LockVote: "0x03c4c7f3"
        case .Reward: "0xcd9d6fca"
        case .RedeemMsaternode: "0xe70c2626"
        case .RedeemLocked: "0xd885085f"
        case .RedeemAvailable: "0x8e5cd5ec"
        case .NodeStateUpload: "0xa6aa19d2"
        case .ProposalVote: "0xb384abef"
        case .ContractDeployment: "0x60806040"
        case .AddLockDay: "0x38e06620"
        }
    }
}
