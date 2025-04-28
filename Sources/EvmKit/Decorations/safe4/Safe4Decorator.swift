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
    public func decoration(from: Address?, to: Address?, value: BigUInt?, contractMethod: ContractMethod?, internalTransactions: [InternalTransaction], eventInstances: [ContractEventInstance], isLock: Bool) -> TransactionDecoration? {
        
        switch contractMethod {

        case is Safe4RedeemAvailableMethod,
            is Safe4RedeemLockedMethod,
            is Safe4RedeemMasterNodeMethod:
            return Safe4RedeemDecoration(from: from, to: to, value: value ?? 0)

        case let _contractMethod as Safe4ProposalVoteMethod:
            let dstAddr = _contractMethod.dstAddr
            return Safe4NodeVoteDecoration(from: from, to: dstAddr, contract: to, value: value ?? 0)
        
        case let _contractMethod as Safe4SuperNodeLockVoteMethod:
            let dstAddr = _contractMethod.dstAddr
            return Safe4NodeVoteDecoration(from: from, to: dstAddr, contract: to, value: value ?? 0)
        
        case let _contractMethod as Safe4SuperNodeVoteMethod:
            let dstAddr = _contractMethod.dstAddr
            return Safe4NodeVoteDecoration(from: from, to: dstAddr, contract: to, value: value ?? 0)
        
        case let _contractMethod as Safe4AppendRegisterMethod:
            let dstAddr = _contractMethod.addr
            return Safe4NodeRegisterDecoration(from: from, to: dstAddr, contract: to, value: value ?? 0)

        case let _contractMethod as Safe4MasterNodeRegisterMethod:
            let dstAddr = _contractMethod.addr
            return Safe4NodeRegisterDecoration(from: from, to: dstAddr, contract: to, value: value ?? 0)

        case let _contractMethod as Safe4SuperNodeRegisterMethod:
            let dstAddr = _contractMethod.addr
            return Safe4NodeRegisterDecoration(from: from, to: dstAddr, contract: to, value: value ?? 0)
            
        case is Safe4NodeStateUploadMethod,
            is Safe4UpdateDescMethod,
            is Safe4NodeUpdateEnodeMethod,
            is Safe4NodeUpdateNameMethod,
            is Safe4NodeDeployMethod,
            is Safe4NodeUpdateAddressMethod:
            return Safe4NodeUpdateDecoration(from: from, to: to, contract: to, value: value ?? 0)
            
        case is Safe4AddLockDayMethod:
            return Safe4AddLockDayDecoration(to: to, value: value ?? 0, sentToSelf: false)
            
        case is Safe4WithdrawMethod:
            guard let from else { return nil}
            let value = internalTransactions.map{$0.value}.reduce(0, +)
            return Safe4WithdrawDecoration(from: from, value: value)
            
        case is Safe4BatchRedeemLockedMethod,
            is Safe4BatchRedeemAvailableMethod:
            return Safe4BatchRedeemDecoration(from: from, to: to, value: value ?? 0)
            
        case is WsafeToSafe4Method, is Safe4Eth2safeMethod, is Safe4ToWsafeMethod:
            guard let from, let to, let value else { return nil }
            if from == address {
                return Safe4CrossChainOutgoingDecoration(from: from, to: to, value: value)
            }
            if to == address {
                return Safe4CrossChainIncomingDecoration(from: from, to: to, value: value)
            }
            
        case let _contractMethod as Safe4DepositMethod:
            if let from, let value, let to {
                if from == address {
                    
                    let sentToSelf : Bool
                    if let address = address(input: _contractMethod.encodedABI()) {
                        sentToSelf = address == from
                    }else {
                        sentToSelf = to == address
                    }
                    return  Safe4DepositOutgoingDecoration(to: to, value: value, sentToSelf: sentToSelf)
                }

                if to == address || isLock == true && to == address {
                    return Safe4DepositIncomingDecoration(from: from, value: value)
                }
            }
        default: ()
        }
        
        guard let from, let value else {
            return nil
        }

        guard let to else {
            return ContractCreationDecoration()
        }

        if let contractMethod, contractMethod is EmptyMethod {
            if from == address {
                return OutgoingDecoration(to: to, value: value, sentToSelf: to == address)
            }

            if to == address {
                return IncomingDecoration(from: from, value: value)
            }
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

