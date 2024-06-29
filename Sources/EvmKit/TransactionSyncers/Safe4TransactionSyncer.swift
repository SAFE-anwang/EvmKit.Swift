import Foundation
import BigInt

class Safe4TransactionSyncer {
    private let syncerId = "safe4-account-manager-transaction-syncer"
    private let address: Address
    private let provider: ITransactionProvider
    private let storage: TransactionSyncerStateStorage

    init(address: Address, provider: ITransactionProvider, storage: TransactionSyncerStateStorage) {
        self.address = address
        self.provider = provider
        self.storage = storage
    }

    private func handle(providerTransactions: [Safe4AccountManagerTransaction]) {
        guard let maxBlockNumber = providerTransactions.map(\.blockNumber).max() else {
            return
        }

        let syncerState = TransactionSyncerState(syncerId: syncerId, lastBlockNumber: maxBlockNumber)
        try? storage.save(syncerState: syncerState)
    }
}

extension Safe4TransactionSyncer: ITransactionSyncer {
    func transactions() async throws -> ([Transaction], Bool) {
        let lastBlockNumber = (try? storage.syncerState(syncerId: syncerId))?.lastBlockNumber ?? 0
        let initial = lastBlockNumber == 0

        do {
            let transactions = try await provider.safe4AccountManagerTransactions(startBlock: lastBlockNumber + 1)

            handle(providerTransactions: transactions)

            let array = transactions
                .filter{ $0.from != address && $0.to == address}
                .map { tx -> Transaction in

                return Transaction(
                    hash: tx.hash,
                    timestamp: tx.timestamp,
                    isFailed: false,
                    blockNumber: tx.blockNumber,
                    from: tx.from,
                    to: tx.to,
                    value: tx.amount,
                    lockDay: tx.lockDay
                )
            }

            return (array, initial)
        } catch {
            return ([], initial)
        }
    }
}
