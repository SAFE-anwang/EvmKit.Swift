import Foundation
import BigInt

class Safe4WithdrawMethodFactory: IContractMethodFactory {
    
    let methodId: Data = Safe4WithdrawMethod().methodId

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        return Safe4WithdrawMethod()
    }
}

class Safe4RedeemAvailableMethodFactory: IContractMethodFactory {
    
    let methodId: Data = Safe4RedeemAvailableMethod().methodId

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        return Safe4RedeemAvailableMethod()
    }
}

class Safe4RedeemLockedMethodFactory: IContractMethodFactory {
    
    let methodId: Data = Safe4RedeemLockedMethod().methodId

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        return Safe4RedeemLockedMethod()
    }
}

class Safe4RedeemMasterNodeMethodFactory: IContractMethodFactory {
    
    let methodId: Data = Safe4RedeemMasterNodeMethod().methodId

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        return Safe4RedeemMasterNodeMethod()
    }
}

class Safe4ProposalVoteMethodFactory: IContractMethodFactory {
    
    let methodId: Data = Safe4ProposalVoteMethod.methodId

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        let parsedArguments = ContractMethodHelper.decodeABI(inputArguments: inputArguments, argumentTypes: [BigUInt.self, EvmKit.Address.self])
        guard let isVote = parsedArguments[0] as? BigUInt,
              let address = parsedArguments[1] as? EvmKit.Address else {
            throw ContractMethodFactories.DecodeError.invalidABI
        }
        return Safe4ProposalVoteMethod(isVote: isVote, dstAddr: address)
    }
}

class Safe4SuperNodeVoteMethodFactory: IContractMethodFactory {
    
    let methodId: Data = Safe4SuperNodeVoteMethod.methodId

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        let parsedArguments = ContractMethodHelper.decodeABI(inputArguments: inputArguments, argumentTypes: [BigUInt.self, EvmKit.Address.self])
        guard let isVote = parsedArguments[0] as? BigUInt,
              let address = parsedArguments[1] as? EvmKit.Address else {
            throw ContractMethodFactories.DecodeError.invalidABI
        }

        return Safe4SuperNodeVoteMethod(isVote: isVote, dstAddr: address)
    }
}

class Safe4SuperNodeLockVoteMethodFactory: IContractMethodFactory {
    
    let methodId: Data = Safe4SuperNodeLockVoteMethod.methodId

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        let parsedArguments = ContractMethodHelper.decodeABI(inputArguments: inputArguments, argumentTypes: [BigUInt.self, EvmKit.Address.self])
        guard let isVote = parsedArguments[0] as? BigUInt,
              let address = parsedArguments[1] as? EvmKit.Address else {
            throw ContractMethodFactories.DecodeError.invalidABI
        }
        return Safe4SuperNodeLockVoteMethod(isVote: isVote, dstAddr: address)
    }
}

class Safe4NodeStateUploadMethodFactory: IContractMethodFactory {
    
    let methodId: Data = Safe4NodeStateUploadMethod().methodId

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        return Safe4NodeStateUploadMethod()
    }
}

class Safe4NodeDeployMethodFactory: IContractMethodFactory {
    
    let methodId: Data = Safe4NodeDeployMethod().methodId

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        return Safe4NodeDeployMethod()
    }
}


class Safe4UpdateDescMethodFactory: IContractMethodFactory {
    
    let methodId: Data = Safe4UpdateDescMethod().methodId

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        return Safe4UpdateDescMethod()
    }
}

class Safe4NodeUpdateEnodeMethodFactory: IContractMethodFactory {
    
    let methodId: Data = Safe4NodeUpdateEnodeMethod().methodId

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        return Safe4NodeUpdateEnodeMethod()
    }
}

class Safe4NodeUpdateNameMethodFactory: IContractMethodFactory {
    
    let methodId: Data = Safe4NodeUpdateNameMethod().methodId

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        return Safe4NodeUpdateNameMethod()
    }
}

class Safe4NodeUpdateAddressMethodFactory: IContractMethodFactory {
    
    let methodId: Data = Safe4NodeUpdateAddressMethod().methodId

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        return Safe4NodeUpdateAddressMethod()
    }
}

class Safe4AppendRegisterMethodFactory: IContractMethodFactory {
    
    let methodId: Data = Safe4AppendRegisterMethod.methodId

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        let parsedArguments = ContractMethodHelper.decodeABI(inputArguments: inputArguments, argumentTypes: [EvmKit.Address.self, BigUInt.self])
        guard let address = parsedArguments[0] as? EvmKit.Address,
              let lockDay = parsedArguments[1] as? BigUInt else {
            throw ContractMethodFactories.DecodeError.invalidABI
        }
        return Safe4AppendRegisterMethod(addr: address, lockDay: lockDay)
    }
}

class Safe4MasterNodeRegisterMethodFactory: IContractMethodFactory {
    
    let methodId: Data = Safe4MasterNodeRegisterMethod.methodId

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        let parsedArguments = ContractMethodHelper.decodeABI(inputArguments: inputArguments, argumentTypes: [BigUInt.self, EvmKit.Address.self, BigUInt.self])
        guard let isUnion = parsedArguments[0] as? BigUInt,
              let address = parsedArguments[1] as? EvmKit.Address,
              let lockDay = parsedArguments[2] as? BigUInt else {
            throw ContractMethodFactories.DecodeError.invalidABI
        }
        return Safe4MasterNodeRegisterMethod(isUnion: isUnion, addr: address, lockDay: lockDay)
    }
}

class Safe4SuperNodeRegisterMethodFactory: IContractMethodFactory {
    
    let methodId: Data = Safe4SuperNodeRegisterMethod.methodId

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        let parsedArguments = ContractMethodHelper.decodeABI(inputArguments: inputArguments, argumentTypes: [BigUInt.self, EvmKit.Address.self, BigUInt.self])
        guard let isUnion = parsedArguments[0] as? BigUInt,
              let address = parsedArguments[1] as? EvmKit.Address,
              let lockDay = parsedArguments[2] as? BigUInt else {
            throw ContractMethodFactories.DecodeError.invalidABI
        }
        return Safe4SuperNodeRegisterMethod(isUnion: isUnion, addr: address, lockDay: lockDay)
    }

}

class Safe4AddLockDayMethodFactory: IContractMethodFactory {
    
    let methodId: Data = Safe4AddLockDayMethod.methodId

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        let parsedArguments = ContractMethodHelper.decodeABI(inputArguments: inputArguments, argumentTypes: [BigUInt.self, BigUInt.self])
        guard let lockId = parsedArguments[0] as? BigUInt,
              let lockDay = parsedArguments[1] as? BigUInt else {
            throw ContractMethodFactories.DecodeError.invalidABI
        }
        return Safe4AddLockDayMethod(lockId: lockId, lockDay: lockDay)
    }
}

class Safe4BatchRedeemLockedMethodFactory: IContractMethodFactory {
    
    let methodId: Data = Safe4BatchRedeemLockedMethod().methodId

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        return Safe4BatchRedeemLockedMethod()
    }
}

class Safe4BatchRedeemAvailableMethodFactory: IContractMethodFactory {
    
    let methodId: Data = Safe4BatchRedeemAvailableMethod().methodId

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        return Safe4BatchRedeemAvailableMethod()
    }
}

class Safe4Eth2safeMethodFactory: IContractMethodFactory {
    
    let methodId: Data = Safe4Eth2safeMethod().methodId

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        return Safe4Eth2safeMethod()
    }
}
class Safe4ToWsafeMethodFactory: IContractMethodFactory {
    
    let methodId: Data = Safe4ToWsafeMethod().methodId

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        return Safe4ToWsafeMethod()
    }
}

class WsafeToSafe4MethodFactory: IContractMethodFactory {
    
    let methodId: Data = WsafeToSafe4Method().methodId

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        return WsafeToSafe4Method()
    }
}
