class Safe4ContractMethodFactories: ContractMethodFactories {
    static let shared = Safe4ContractMethodFactories()

    override init() {
        super.init()
        register(factories: [
            DepositMethodFactory()
        ])
    }
}
