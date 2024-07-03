import Foundation
import BigInt

class Safe4WithdrawMethodFactory: IContractMethodFactory {
    
    let methodId: Data = ContractMethodHelper.methodId(signature: Safe4WithdrawMethod.methodSignature)

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        return Safe4WithdrawMethod()
    }
}
