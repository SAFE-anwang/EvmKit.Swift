class Safe4ContractMethodFactories: ContractMethodFactories {
    static let shared = Safe4ContractMethodFactories()

    override init() {
        super.init()
        
        register(factories: [
            DepositMethodFactory(),
            Safe4WithdrawMethodFactory(),
            Safe4RedeemAvailableMethodFactory(),
            Safe4RedeemLockedMethodFactory(),
            Safe4RedeemMasterNodeMethodFactory(),
            Safe4ProposalVoteMethodFactory(),
            Safe4SuperNodeVoteMethodFactory(),
            Safe4NodeStateUploadMethodFactory(),
            Safe4SuperNodeLockVoteMethodFactory(),
            Safe4NodeDeployMethodFactory(),
            Safe4UpdateDescMethodFactory(),
            Safe4NodeUpdateEnodeMethodFactory(),
            Safe4NodeUpdateNameMethodFactory(),
            Safe4NodeUpdateAddressMethodFactory(),
            Safe4AppendRegisterMethodFactory(),
            Safe4MasterNodeRegisterMethodFactory(),
            Safe4SuperNodeRegisterMethodFactory(),
            Safe4AddLockDayMethodFactory(),
            Safe4BatchRedeemLockedMethodFactory(),
            Safe4BatchRedeemAvailableMethodFactory(),
            Safe4Eth2safeMethodFactory(),
            BscToSafe4MethodFactory(),
            EthToSafe4MethodFactory(),
            PolToSafe4MethodFactory(),
            Safe4ToBscMethodFactory(),
            Safe4ToEthMethodFactory(),
            Safe4ToPolMethodFactory()
        ])
    }
}
