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

class Safe4BatchRedeemLockedMethod: ContractMethod {
    static let methodId: Data = Safe4Methods.BatchRedeemLocked.id.hs.hexData ?? Data()

    override var methodId: Data {
        Self.methodId
    }
    
    override init() {}

    override var methodSignature: String { "" }

    override var arguments: [Any] {[]}
}

class Safe4BatchRedeemAvailableMethod: ContractMethod {
    static let methodId: Data = Safe4Methods.BatchRedeemAvailable.id.hs.hexData ?? Data()

    override var methodId: Data {
        Self.methodId
    }
    
    override init() {}

    override var methodSignature: String { "" }

    override var arguments: [Any] {[]}
}

class Safe4Eth2safeMethod: ContractMethod {
    static let methodId: Data = Safe4Methods.Eth2safe.id.hs.hexData ?? Data()

    override var methodId: Data { Self.methodId }
    
    override init() {}

    override var methodSignature: String { "" }

    override var arguments: [Any] {[]}
}

class BscToSafe4Method: ContractMethod {
    static let methodId: Data = Safe4Methods.bscToSafe4.id.hs.hexData ?? Data()
    override var methodId: Data { Self.methodId }
    override init() {}
    override var methodSignature: String { "" }
    override var arguments: [Any] {[]}
}

class EthToSafe4Method: ContractMethod {
    static let methodId: Data = Safe4Methods.ethToSafe4.id.hs.hexData ?? Data()
    override var methodId: Data { Self.methodId }
    override init() {}
    override var methodSignature: String { "" }
    override var arguments: [Any] {[]}
}

class PolToSafe4Method: ContractMethod {
    static let methodId: Data = Safe4Methods.polToSafe4.id.hs.hexData ?? Data()
    override var methodId: Data { Self.methodId }
    override init() {}
    override var methodSignature: String { "" }
    override var arguments: [Any] {[]}
}

class Safe4ToBscMethod: ContractMethod {
    static let methodId: Data = Safe4Methods.safe4ToBsc.id.hs.hexData ?? Data()
    override var methodId: Data { Self.methodId }
    override init() {}
    override var methodSignature: String { "" }
    override var arguments: [Any] {[]}
}

class Safe4ToEthMethod: ContractMethod {
    static let methodId: Data = Safe4Methods.safe4ToEth.id.hs.hexData ?? Data()
    override var methodId: Data { Self.methodId }
    override init() {}
    override var methodSignature: String { "" }
    override var arguments: [Any] {[]}
}

class Safe4ToPolMethod: ContractMethod {
    static let methodId: Data = Safe4Methods.safe4ToPol.id.hs.hexData ?? Data()
    override var methodId: Data { Self.methodId }
    override init() {}
    override var methodSignature: String { "" }
    override var arguments: [Any] {[]}
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
    case BatchRedeemLocked // 锁仓余额迁移
    case BatchRedeemAvailable // 余额迁移
    case Eth2safe
    case bscToSafe4
    case ethToSafe4
    case polToSafe4
    case safe4ToBsc
    case safe4ToEth
    case safe4ToPol
    
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
        case .BatchRedeemLocked: "0x4c9e906a"
        case .BatchRedeemAvailable: "0xdb5b287d"
        case .Eth2safe: "0xbc157d0c"
        case .bscToSafe4: "0x6269643a"
        case .ethToSafe4: "0x6569643a"
        case .polToSafe4: "0x6d69643a"
        case .safe4ToBsc: "0x6273633a"
        case .safe4ToEth: "0x6574683a"
        case .safe4ToPol: "0x6d617469"
        }
    }
}
