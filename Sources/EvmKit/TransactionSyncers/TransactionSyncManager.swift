import BigInt
import Combine
import Foundation
import HsExtensions

class TransactionSyncManager {
    private let transactionManager: TransactionManager
    private var tasks = Set<AnyTask>()

    private var _syncers = [ITransactionSyncer]()

    private let queue = DispatchQueue(label: "io.horizontal-systems.ethereum-kit.transaction-sync-manager", qos: .userInitiated)

    private let stateSubject = PassthroughSubject<SyncState, Never>()
    private var _state: SyncState = .notSynced(error: Kit.SyncError.notStarted) {
        didSet {
            if _state != oldValue {
                stateSubject.send(_state)
            }
        }
    }

    init(transactionManager: TransactionManager) {
        self.transactionManager = transactionManager
    }

    private struct SyncResult {
        let index: Int
        let kind: TransactionSyncerKind
        let transactions: [Transaction]
        let initial: Bool
    }

    private func _handle(resultArray: [SyncResult]) {
        let orderedResults = resultArray.sorted {
            if $0.kind.rawValue != $1.kind.rawValue {
                return $0.kind.rawValue < $1.kind.rawValue
            }
            return $0.index < $1.index
        }
        let transactions = Array(orderedResults.flatMap(\.transactions))
        let initial = orderedResults.map(\.initial).allSatisfy { $0 }

        var dictionary = [Data: Transaction]()

        for transaction in transactions {
            if let existingTransaction = dictionary[transaction.hash] {
                dictionary[transaction.hash] = Self.merge(lhsTransaction: existingTransaction, rhsTransaction: transaction)
            } else {
                dictionary[transaction.hash] = transaction
            }
        }

        transactionManager.handle(transactions: Array(dictionary.values), initial: initial)
    }

    static func merge(lhsTransaction lhs: Transaction, rhsTransaction rhs: Transaction, isLocked: Bool = false) -> Transaction {
        Transaction(
            hash: lhs.hash,
            timestamp: lhs.timestamp,
            isFailed: isLocked ? lhs.isFailed : lhs.isFailed || rhs.isFailed,
            blockNumber: lhs.blockNumber ?? rhs.blockNumber,
            transactionIndex: lhs.transactionIndex ?? rhs.transactionIndex,
            from: lhs.from ?? rhs.from,
            to: lhs.to ?? rhs.to,
            value: lhs.value ?? rhs.value,
            safe4Value: lhs.safe4Value ?? rhs.safe4Value,
            input: lhs.input ?? rhs.input,
            nonce: lhs.nonce ?? rhs.nonce,
            gasPrice: lhs.gasPrice ?? rhs.gasPrice,
            maxFeePerGas: lhs.maxFeePerGas ?? rhs.maxFeePerGas,
            maxPriorityFeePerGas: lhs.maxPriorityFeePerGas ?? rhs.maxPriorityFeePerGas,
            gasLimit: lhs.gasLimit ?? rhs.gasLimit,
            gasUsed: lhs.gasUsed ?? rhs.gasUsed,
            replacedWith: lhs.replacedWith ?? rhs.replacedWith,
            lockDay: lhs.lockDay ?? rhs.lockDay
            
        )
    }

    private func handleSuccess(resultArray: [SyncResult]) {
        queue.async {
            self._handle(resultArray: resultArray)
            self._state = .synced
        }
    }

    private func handleError(error: Error) {
        queue.async {
            self._state = .notSynced(error: error)
        }
    }

    private func _sync() {
        guard !_state.syncing else {
            return
        }

        _state = .syncing(progress: nil)

        Task { [weak self, _syncers] in
            do {
                let resultArray = try await withThrowingTaskGroup(of: SyncResult.self) { group in
                    for (index, syncer) in _syncers.enumerated() {
                        group.addTask {
                            let (transactions, initial) = try await syncer.transactions()
                            return SyncResult(index: index, kind: syncer.kind, transactions: transactions, initial: initial)
                        }
                    }

                    var array = [SyncResult]()

                    for try await result in group {
                        array.append(result)
                    }

                    return array
                }

                self?.handleSuccess(resultArray: resultArray)
            } catch {
                self?.handleError(error: error)
            }
        }.store(in: &tasks)
    }
}

extension TransactionSyncManager {
    var statePublisher: AnyPublisher<SyncState, Never> {
        stateSubject.eraseToAnyPublisher()
    }

    var state: SyncState {
        queue.sync {
            _state
        }
    }

    func add(syncer: ITransactionSyncer) {
        queue.async {
            self._syncers.append(syncer)
        }
    }

    func set(syncers: [ITransactionSyncer]) {
        queue.async {
            self._syncers = syncers
        }
    }

    func sync() {
        queue.async {
            self._sync()
        }
    }
}
