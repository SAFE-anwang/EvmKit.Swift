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
    public let transactionIndex: FlexibleValue // Int
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
        transactionIndex = try map.value("transactionIndex", using: FlexibleValueTransform())
        gasLimit = try map.value("gas", using: FlexibleValueTransform())
        gasPrice = try map.value("gasPrice", using: FlexibleValueTransform())
        gasUsed = try map.value("gasUsed", using: FlexibleValueTransform())
        cumulativeGasUsed = try map.value("cumulativeGasUsed", using: FlexibleValueTransform())
    }
}
