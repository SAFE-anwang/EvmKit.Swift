import Foundation

class Safe4RedeemAvailableMethodFactory: IContractMethodFactory {
    
    let methodId: Data = ContractMethodHelper.methodId(signature: Safe4RedeemAvailableMethod.methodSignature)

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        return Safe4RedeemAvailableMethod()
    }
}

class Safe4RedeemLockedMethodFactory: IContractMethodFactory {
    
    let methodId: Data = ContractMethodHelper.methodId(signature: Safe4RedeemLockedMethod.methodSignature)

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        return Safe4RedeemLockedMethod()
    }
}

class Safe4RedeemMasterNodeMethodFactory: IContractMethodFactory {
    
    let methodId: Data = ContractMethodHelper.methodId(signature: Safe4RedeemMasterNodeMethod.methodSignature)

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        return Safe4RedeemMasterNodeMethod()
    }
}
