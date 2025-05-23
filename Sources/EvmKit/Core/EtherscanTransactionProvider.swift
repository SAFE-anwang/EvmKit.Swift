import Alamofire
import BigInt
import Foundation
import HsToolKit

class EtherscanTransactionProvider {
    private let networkManager: NetworkManager
    private let baseUrl: String
    private let address: Address
    private let syncedState: SyncedState

    init(baseUrl: String, apiKeys: [String], address: Address, logger: Logger) {
        networkManager = NetworkManager(logger: logger)
        self.baseUrl = baseUrl
        self.address = address

        syncedState = .init(apiKeys: apiKeys)
    }

    private func fetch(params: [String: Any], retryCount: Int = 0) async throws -> [[String: Any]] {
        if let delay = await syncedState.getDelay() {
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }

        let urlString = "\(baseUrl)/api"

        var parameters = params
        parameters["apikey"] = await syncedState.getApiKey()

        let json = try await networkManager.fetchJson(url: urlString, method: .get, parameters: parameters, responseCacherBehavior: .doNotCache)

        guard let map = json as? [String: Any] else {
            throw RequestError.invalidResponse
        }

        guard let status = map["status"] as? String else {
            throw RequestError.invalidStatus
        }

        guard status == "1" else {
            let message = map["message"] as? String
            let result = map["result"] as? String

            // Etherscan API returns status 0 if no transactions found.
            // It is not error case, so we should not throw an error.
            if message == "No transactions found" {
                return []
            }

            if message == "NOTOK", let result, result.contains("limit reached") {
                if retryCount < 2 {
                    return try await fetch(params: params, retryCount: retryCount + 1)
                }

                throw RequestError.rateLimitExceeded
            }

            throw RequestError.responseError(message: message, result: result)
        }

        guard let result = map["result"] as? [[String: Any]] else {
            throw RequestError.invalidResult
        }

        return result
    }
}

extension EtherscanTransactionProvider: ITransactionProvider {
    func transactions(startBlock: Int) async throws -> [ProviderTransaction] {
        let params: [String: Any] = [
            "module": "account",
            "action": "txlist",
            "address": address.hex,
            "startblock": startBlock,
            "sort": "desc",
        ]

        let array = try await fetch(params: params)
        return array.compactMap { try? ProviderTransaction(JSON: $0) }
    }

    func internalTransactions(startBlock: Int) async throws -> [ProviderInternalTransaction] {
        let params: [String: Any] = [
            "module": "account",
            "action": "txlistinternal",
            "address": address.hex,
            "startblock": startBlock,
            "sort": "desc",
        ]

        let array = try await fetch(params: params)
        return array.compactMap { try? ProviderInternalTransaction(JSON: $0) }
    }

    func internalTransactions(transactionHash: Data) async throws -> [ProviderInternalTransaction] {
        let params: [String: Any] = [
            "module": "account",
            "action": "txlistinternal",
            "txhash": transactionHash.hs.hexString,
            "sort": "desc",
        ]

        let array = try await fetch(params: params)
        return array.compactMap { try? ProviderInternalTransaction(JSON: $0) }
    }

    func tokenTransactions(startBlock: Int) async throws -> [ProviderTokenTransaction] {
        let params: [String: Any] = [
            "module": "account",
            "action": "tokentx",
            "address": address.hex,
            "startblock": startBlock,
            "sort": "desc",
        ]

        let array = try await fetch(params: params)
        return array.compactMap { try? ProviderTokenTransaction(JSON: $0) }
    }

    public func eip721Transactions(startBlock: Int) async throws -> [ProviderEip721Transaction] {
        let params: [String: Any] = [
            "module": "account",
            "action": "tokennfttx",
            "address": address.hex,
            "startblock": startBlock,
            "sort": "desc",
        ]

        let array = try await fetch(params: params)
        return array.compactMap { try? ProviderEip721Transaction(JSON: $0) }
    }

    public func eip1155Transactions(startBlock: Int) async throws -> [ProviderEip1155Transaction] {
        let params: [String: Any] = [
            "module": "account",
            "action": "token1155tx",
            "address": address.hex,
            "startblock": startBlock,
            "sort": "desc",
        ]

        let array = try await fetch(params: params)
        return array.compactMap { try? ProviderEip1155Transaction(JSON: $0) }
    }
    
    func safe4AccountManagerTransactions(startBlock: Int) async throws -> [Safe4AccountManagerTransaction] {
        let params: [String: Any] = [
            "module": "account",
            "action": "accountmanager",
            "address": address.hex,
            "startblock": startBlock,
            "sort": "desc",
        ]

        let array = try await fetch(params: params)

        return array.compactMap { try? Safe4AccountManagerTransaction(JSON: $0) }
    }
}

extension EtherscanTransactionProvider {
    public enum RequestError: Error {
        case invalidResponse
        case invalidStatus
        case responseError(message: String?, result: String?)
        case invalidResult
        case rateLimitExceeded
    }

    actor SyncedState {
        private let apiKeys: [String]
        private var index = 0
        private var nextRequestTime: TimeInterval = 0

        init(apiKeys: [String]) {
            self.apiKeys = apiKeys
        }

        func getApiKey() -> String {
            index = (index + 1) % apiKeys.count
            return apiKeys[index]
        }

        func getDelay() -> TimeInterval? {
            let interval: TimeInterval = 1
            let now = Date().timeIntervalSince1970

            if now > nextRequestTime {
                nextRequestTime = now + interval
                return nil
            } else {
                let delay = nextRequestTime - now
                nextRequestTime += interval
                return delay
            }
        }
    }
}
