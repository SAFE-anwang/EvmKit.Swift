import BigInt

class EthereumTransactionSyncer {
    private let syncerId = "ethereum-transaction-syncer"

    private let provider: ITransactionProvider
    private let storage: TransactionSyncerStateStorage

    init(provider: ITransactionProvider, storage: TransactionSyncerStateStorage) {
        self.provider = provider
        self.storage = storage
    }

    private func handle(providerTransactions: [ProviderTransaction]) {
        guard let maxBlockNumber = providerTransactions.map(\.blockNumber).max() else {
            return
        }

        let syncerState = TransactionSyncerState(syncerId: syncerId, lastBlockNumber: maxBlockNumber)
        try? storage.save(syncerState: syncerState)
    }
}

extension EthereumTransactionSyncer: ITransactionSyncer {
    func transactions() async throws -> ([Transaction], Bool) {
        let lastBlockNumber = (try? storage.syncerState(syncerId: syncerId))?.lastBlockNumber ?? 0
        let initial = lastBlockNumber == 0

        do {
            let transactions = try await provider.transactions(startBlock: lastBlockNumber + 1)

            handle(providerTransactions: transactions)

            let array = transactions.map { tx -> Transaction in
                var isFailed: Bool

                if let status = tx.txReceiptStatus {
                    isFailed = status != 1
                } else if let isError = tx.isError {
                    isFailed = isError != 0
                } else if let gasUsed = tx.gasUsed {
                    isFailed = tx.gasLimit == gasUsed
                } else {
                    isFailed = false
                }

                return Transaction(
                    hash: tx.hash,
                    timestamp: tx.timestamp,
                    isFailed: isFailed,
                    blockNumber: tx.blockNumber,
                    transactionIndex: tx.transactionIndex,
                    from: tx.from,
                    to: tx.to,
                    value: tx.value > 0 ? tx.value : nil,
                    input: tx.input,
                    nonce: tx.nonce,
                    gasPrice: tx.gasPrice,
                    gasUsed: tx.gasUsed
                )
            }

            return (array, initial)
        } catch {
            return ([], initial)
        }
    }
}
