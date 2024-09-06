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
