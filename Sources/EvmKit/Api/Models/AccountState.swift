import BigInt
import GRDB

public class AccountState: Record {
    private static let primaryKey = "primaryKey"

    private let primaryKey: String = AccountState.primaryKey

    public let balance: BigUInt
    public let nonce: Int
    public let timeLockBalance: BigUInt
    
    init(balance: BigUInt, nonce: Int, timeLockBalance: BigUInt = .zero) {
        self.balance = balance
        self.nonce = nonce
        self.timeLockBalance = timeLockBalance
        super.init()
    }

    override public class var databaseTableName: String {
        "account_states"
    }

    enum Columns: String, ColumnExpression {
        case primaryKey
        case balance
        case nonce
        case timeLockBalance
    }

    required init(row: Row) throws {
        balance = row[Columns.balance]
        nonce = row[Columns.nonce]
        timeLockBalance = row[Columns.timeLockBalance]
        try super.init(row: row)
    }

    override public func encode(to container: inout PersistenceContainer) throws {
        container[Columns.primaryKey] = primaryKey
        container[Columns.balance] = balance
        container[Columns.nonce] = nonce
        container[Columns.timeLockBalance] = timeLockBalance
    }
}

extension AccountState: Equatable {
    public static func == (lhs: AccountState, rhs: AccountState) -> Bool {
        lhs.balance == rhs.balance && lhs.nonce == rhs.nonce && lhs.timeLockBalance == rhs.timeLockBalance
    }
}
