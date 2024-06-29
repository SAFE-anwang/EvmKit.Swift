import Foundation
import BigInt

class DepositMethodFactory: IContractMethodFactory {
    
    let methodId: Data = ContractMethodHelper.methodId(signature: Safe4DepositMethod.methodSignature)

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        let parsedArguments = ContractMethodHelper.decodeABI(inputArguments: inputArguments, argumentTypes: [Address.self, BigUInt.self])
        guard let owner = parsedArguments[0] as? Address,
              let lockDay = parsedArguments[1] as? BigUInt else {
            throw ContractMethodFactories.DecodeError.invalidABI
        }

        return Safe4DepositMethod(owner: owner, lockDay: lockDay)
    }

}
