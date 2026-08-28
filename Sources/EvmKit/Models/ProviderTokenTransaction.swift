import BigInt
import Foundation
import ObjectMapper
import HsToolKit

public struct ProviderTokenTransaction: ImmutableMappable {
    public let blockNumber: Int
    public let timestamp: Int
    public let hash: Data
    public let nonce: Int
    public let blockHash: Data
    public let from: Address
    public let contractAddress: Address
    public let to: Address
    public let value: BigUInt
    public let tokenName: String
    public let tokenSymbol: String
    public let tokenDecimal: FlexibleValue
    public let transactionIndex: FlexibleValue? // Int
    public let gasLimit: FlexibleValue // Int
    public let gasPrice: FlexibleValue // Int
    public let gasUsed: FlexibleValue // Int
    public let cumulativeGasUsed: FlexibleValue // Int

    public init(map: Map) throws {
        blockNumber = try map.value("blockNumber", using: StringIntTransform())
        timestamp = try map.value("timeStamp", using: StringIntTransform())
        hash = try map.value("hash", using: HexDataTransform())
        nonce = try map.value("nonce", using: StringIntTransform())
        blockHash = try map.value("blockHash", using: HexDataTransform())
        from = try map.value("from", using: HexAddressTransform())
        contractAddress = try map.value("contractAddress", using: HexAddressTransform())
        to = try map.value("to", using: HexAddressTransform())
        value = try map.value("value", using: StringBigUIntTransform())
        tokenName = try map.value("tokenName")
        tokenSymbol = try map.value("tokenSymbol")
        tokenDecimal = try map.value("tokenDecimal", using: FlexibleValueTransform())
        transactionIndex = try? map.value("transactionIndex", using: FlexibleValueTransform())
        gasLimit = try map.value("gas", using: FlexibleValueTransform())
        gasPrice = try map.value("gasPrice", using: FlexibleValueTransform())
        gasUsed = try map.value("gasUsed", using: FlexibleValueTransform())
        cumulativeGasUsed = try map.value("cumulativeGasUsed", using: FlexibleValueTransform())
    }

    public init(
        hash: Data,
        from: Address,
        contractAddress: Address,
        to: Address,
        value: BigUInt,
        blockNumber: Int = 0,
        timestamp: Int = 0,
        nonce: Int = 0,
        blockHash: Data = Data(),
        tokenName: String = "",
        tokenSymbol: String = "",
        tokenDecimal: Int = 0,
        transactionIndex: Int = 0,
        gasLimit: Int = 0,
        gasPrice: Int = 0,
        gasUsed: Int = 0,
        cumulativeGasUsed: Int = 0
    ) {
        self.blockNumber = blockNumber
        self.timestamp = timestamp
        self.hash = hash
        self.nonce = nonce
        self.blockHash = blockHash
        self.from = from
        self.contractAddress = contractAddress
        self.to = to
        self.value = value
        self.tokenName = tokenName
        self.tokenSymbol = tokenSymbol
        self.tokenDecimal = .int(tokenDecimal)
        self.transactionIndex = FlexibleValue.int(transactionIndex)
        self.gasLimit = .int(gasLimit)
        self.gasPrice = .int(gasPrice)
        self.gasUsed = .int(gasUsed)
        self.cumulativeGasUsed = .int(cumulativeGasUsed)
    }
}
