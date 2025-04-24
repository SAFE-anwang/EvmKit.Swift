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
            let tempArray = transactions.filter{$0.action != "SafeWithdraw"}
            let duplicates = findDuplicates(in: tempArray)
            handle(providerTransactions: transactions)

            let array = transactions.map { tx -> Transaction in

                var  total = tx.amount
                if let num = duplicates[tx.hash] {
                    total = total * BigUInt(num)
                }

                return Transaction(
                    hash: tx.hash,
                    timestamp: tx.timestamp,
                    isFailed: false,
                    blockNumber: tx.blockNumber,
                    from: tx.from,
                    to: tx.to,
                    value: total,//tx.amount,
                    lockDay: tx.lockDay
                )
            }

            return (array, initial)
        } catch {
            return ([], initial)
        }
    }
    
    func findDuplicates(in array: [Safe4AccountManagerTransaction]) -> [Data: Int] {
        var elementCount: [Data: Int] = [:]
        for element in array {
            elementCount[element.hash, default: 0] += 1
        }
        let duplicates = elementCount.filter { $0.value > 1 }
        return duplicates
    }
}

