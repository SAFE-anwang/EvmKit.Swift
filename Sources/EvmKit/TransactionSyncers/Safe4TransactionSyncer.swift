import Foundation
import BigInt

class Safe4TransactionSyncer {
    private let syncerId = "safe4-account-manager-transaction-syncer"
    private let address: Address
    private let provider: ITransactionProvider
    private let storage: TransactionSyncerStateStorage
    private let manager: Safe4CustomTokenManager
    init(address: Address, provider: ITransactionProvider, storage: TransactionSyncerStateStorage, manager: Safe4CustomTokenManager) {
        self.address = address
        self.provider = provider
        self.storage = storage
        self.manager = manager
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
    var kind: TransactionSyncerKind { .safe4 }

    func transactions() async throws -> ([Transaction], Bool) {
        let lastBlockNumber = (try? storage.syncerState(syncerId: syncerId))?.lastBlockNumber ?? 0
        let initial = lastBlockNumber == 0

        do {
            if initial {
                try await manager.requestCustomTokens()
            }
            let providerTransactions = try await provider.safe4AccountManagerTransactions(startBlock: lastBlockNumber + 1)
            handle(providerTransactions: providerTransactions)

            let array = mergedTransactions(providerTransactions: providerTransactions)
            return (array, initial)
        } catch {
            return ([], initial)
        }
    }

    private func mergedTransactions(providerTransactions: [Safe4AccountManagerTransaction]) -> [Transaction] {
        // "SafeWithdraw" events are intermediate split records and should not be shown as standalone rows.
        let filteredTransactions = providerTransactions.filter { $0.action != "SafeWithdraw" }
        let groupedTransactions = Dictionary(grouping: filteredTransactions, by: \.hash)

        return groupedTransactions.compactMap { _, group in
            guard !group.isEmpty else {
                return nil
            }

            var seenKeys = Set<String>()
            var uniqueTransactions = [Safe4AccountManagerTransaction]()

            for transaction in group {
                let deduplicationKey = deduplicationKey(transaction: transaction)
                if seenKeys.insert(deduplicationKey).inserted {
                    uniqueTransactions.append(transaction)
                }
            }

            guard let baseTransaction = uniqueTransactions.min(by: baseTransactionComparator) ?? uniqueTransactions.first else {
                return nil
            }

            let totalAmount = uniqueTransactions.reduce(BigUInt.zero) { partialResult, transaction in
                partialResult + transaction.amount
            }
            let blockNumber = uniqueTransactions.map(\.blockNumber).max() ?? baseTransaction.blockNumber
            let timestamp = uniqueTransactions.map(\.timestamp).max() ?? baseTransaction.timestamp

            return Transaction(
                hash: baseTransaction.hash,
                timestamp: timestamp,
                isFailed: false,
                blockNumber: blockNumber,
                from: baseTransaction.from,
                to: baseTransaction.to,
                lockDay: baseTransaction.lockDay,
                safe4Value: totalAmount
            )
        }
    }

    private func deduplicationKey(transaction: Safe4AccountManagerTransaction) -> String {
        if transaction.eventLogIndex >= 0 {
            return "event:\(transaction.eventLogIndex)"
        }

        if !transaction.lockId.isEmpty {
            return "lock:\(transaction.lockId)"
        }

        return [
            "fallback",
            transaction.action,
            transaction.from?.hex.lowercased() ?? "",
            transaction.to?.hex.lowercased() ?? "",
            transaction.amount.description,
            "\(transaction.timestamp)",
            "\(transaction.blockNumber)",
        ].joined(separator: "|")
    }

    private func baseTransactionComparator(lhs: Safe4AccountManagerTransaction, rhs: Safe4AccountManagerTransaction) -> Bool {
        if lhs.eventLogIndex != rhs.eventLogIndex {
            return lhs.eventLogIndex < rhs.eventLogIndex
        }

        if lhs.timestamp != rhs.timestamp {
            return lhs.timestamp < rhs.timestamp
        }

        return lhs.lockId < rhs.lockId
    }
}
