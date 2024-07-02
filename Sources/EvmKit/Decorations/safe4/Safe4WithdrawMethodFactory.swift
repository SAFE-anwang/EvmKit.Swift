import Foundation
import BigInt

class Safe4WithdrawMethodFactory: IContractMethodFactory {
    
    let methodId: Data = ContractMethodHelper.methodId(signature: Safe4WithdrawMethod.methodSignature)

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        let parsedArguments = ContractMethodHelper.decodeABI(inputArguments: inputArguments, argumentTypes: [])
        return Safe4WithdrawMethod()
    }
}
