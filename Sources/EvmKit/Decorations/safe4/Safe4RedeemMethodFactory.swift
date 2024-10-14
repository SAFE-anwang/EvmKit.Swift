import Foundation
import BigInt

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


