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
            Safe4NodeDeployMethodFactory()
        ])
    }
}
