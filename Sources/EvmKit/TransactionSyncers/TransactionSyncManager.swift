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

    private func _handle(resultArray: [([Transaction], Bool)]) {
        let transactions = Array(resultArray.map(\.0).joined())
        let initial = resultArray.map(\.1).allSatisfy { $0 }

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
            isFailed: isLocked ? lhs.isFailed : rhs.isFailed,
            blockNumber: lhs.blockNumber ?? rhs.blockNumber,
            transactionIndex: lhs.transactionIndex ?? rhs.transactionIndex,
            from: lhs.from ?? rhs.from,
            to: lhs.to ?? rhs.to,
            value: lhs.value ?? rhs.value,
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

    private func handleSuccess(resultArray: [([Transaction], Bool)]) {
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
                let resultArray = try await withThrowingTaskGroup(of: ([Transaction], Bool).self) { group in
                    for syncer in _syncers {
                        group.addTask {
                            try await syncer.transactions()
                        }
                    }

                    var array = [([Transaction], Bool)]()

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

    func sync() {
        queue.async {
            self._sync()
        }
    }
}
