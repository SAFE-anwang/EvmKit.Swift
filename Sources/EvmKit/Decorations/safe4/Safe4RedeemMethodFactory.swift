import Foundation

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
    
    let methodId: Data = Safe4ProposalVoteMethod().methodId

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        return Safe4ProposalVoteMethod()
    }
}

class Safe4SuperNodeVoteMethodFactory: IContractMethodFactory {
    
    let methodId: Data = Safe4SuperNodeVoteMethod().methodId

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        return Safe4SuperNodeVoteMethod()
    }
}

class Safe4NodeStateUploadMethodFactory: IContractMethodFactory {
    
    let methodId: Data = Safe4NodeStateUploadMethod().methodId

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        return Safe4NodeStateUploadMethod()
    }
}
