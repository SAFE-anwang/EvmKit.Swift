import Foundation
import BigInt
import web3swift
import Web3Core

class Safe4Decorator {
    private let address: Address

    init(address: Address) {
        self.address = address
    }
}

extension Safe4Decorator: ITransactionDecorator {
    public func decoration(from: Address?, to: Address?, value: BigUInt?, contractMethod: ContractMethod?, internalTransactions _: [InternalTransaction], eventInstances _: [ContractEventInstance], isLock: Bool) -> TransactionDecoration? {
        
        switch contractMethod {
            case is Safe4RedeemAvailableMethod,
                is Safe4RedeemLockedMethod,
                is Safe4RedeemMasterNodeMethod:
                return Safe4RedeemDecoration(from: from, to: to, value: value ?? 0)
                
            case is Safe4ProposalVoteMethod,
                is Safe4SuperNodeLockVoteMethod,
                is Safe4SuperNodeVoteMethod,
                is Safe4NodeDeployMethod:
                return Safe4NodeVoteDecoration(from: from, to: to, contract: to, value: value ?? 0)
                
            case is Safe4NodeStateUploadMethod,
                is Safe4UpdateDescMethod,
                is Safe4NodeUpdateEnodeMethod,
                is Safe4NodeUpdateNameMethod,
                is Safe4NodeUpdateAddressMethod:
                return Safe4NodeUpdateDecoration(from: from, to: to, contract: to, value: value ?? 0)
                
            default: ()
        }
            
        guard let from, let value else {
            return nil
        }

        guard let to else {
            return ContractCreationDecoration()
        }

        if let contractMethod, contractMethod is Safe4DepositMethod {
            if from == address {
                
                let sentToSelf : Bool
                if let address = address(input: contractMethod.encodedABI()) {
                    sentToSelf = address == from
                }else {
                    sentToSelf = to == address
                }
                return  Safe4DepositOutgoingDecoration(to: to, value: value, sentToSelf: sentToSelf)
            }

            if to == address {
                return Safe4DepositIncomingDecoration(from: from, value: value)
            }
        }
        
        if let contractMethod, contractMethod is Safe4WithdrawMethod {
            let from = try! Address(hex: Safe4ContractAddress.AccountManagerContractAddr)
            return  Safe4WithdrawDecoration(from: from, value: value)
        }
        
        if (isLock == true && to == address) {
            return Safe4DepositIncomingDecoration(from: from, value: value)
        }
        

        return nil
    }
}

extension Safe4Decorator {
    private func address(input: Data?) -> Address? {
        guard let input else { return nil }
        let parsedArguments = ContractMethodHelper.decodeABI(inputArguments: Data(input.suffix(from: 4)), argumentTypes: [EvmKit.Address.self])
        let owner = parsedArguments[0] as? EvmKit.Address
        return owner
    }
}

