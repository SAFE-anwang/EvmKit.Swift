import Foundation
import BigInt

public class Safe4MethodDecorator: IMethodDecorator {
    private let contractMethodFactories: ContractMethodFactories
    
    init(contractMethodFactories: ContractMethodFactories) {
        self.contractMethodFactories = contractMethodFactories
    }
    
    public func contractMethod(input: Data) -> ContractMethod? {
        return contractMethodFactories.createMethod(input: input)
    }
}
