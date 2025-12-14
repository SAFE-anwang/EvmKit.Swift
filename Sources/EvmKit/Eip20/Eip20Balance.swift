import BigInt
import GRDB

class Eip20Balance: Record {
    let contractAddress: String
    let value: BigUInt?
    let locked: BigUInt?
    
    init(contractAddress: String, value: BigUInt?, locked: BigUInt?) {
        self.contractAddress = contractAddress
        self.value = value
        self.locked = locked
        super.init()
    }

    override class var databaseTableName: String {
        "eip20_balances"
    }

    enum Columns: String, ColumnExpression {
        case contractAddress
        case value
        case locked
    }

    required init(row: Row) throws {
        contractAddress = row[Columns.contractAddress]
        value = row[Columns.value]
        locked = row[Columns.locked]
        try super.init(row: row)
    }

    override func encode(to container: inout PersistenceContainer) throws {
        container[Columns.contractAddress] = contractAddress
        container[Columns.value] = value
        container[Columns.locked] = locked
    }
}
