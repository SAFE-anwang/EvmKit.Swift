import Foundation
import HsToolKit
import ObjectMapper

open class Safe4CustomTokenManager {
    public static let safe4DeployContractsKey = "Safe4DeployContractsKey"

    private let chain: Chain
    init(chain: Chain) {
        self.chain = chain
    }
    
    func requestCustomTokens() async throws {
        
        let baseUrl = chain == Chain.SafeFourTestNet ? "https://safe4testnet.anwang.com" : "https://safe4.anwang.com"
        let urlString = "\(baseUrl)/list/token"
        let logger = Logger(minLogLevel: .error)
        let networkManager = NetworkManager(logger: logger)
        
        let json = try await networkManager.fetchJson(url: urlString, method: .get, parameters: [:], responseCacherBehavior: .doNotCache)
        guard let map = json as? [String: Any] else {
            return
        }
        guard let result = map["tokens"] as? [[String: Any]] else {
            return
        }
        if var addressArray = result.map({$0["address"]}) as? [String] {
            let native = "0x0000000000000000000000000000000000001101"
            if let index = addressArray.firstIndex(where: { $0 == native }) {
                addressArray.remove(at: index)
            }
            UserDefaults.standard.set(addressArray.map({$0.lowercased()}), forKey: Safe4CustomTokenManager.safe4DeployContractsKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    static func safe4DeployContracts() -> [String]? {
        UserDefaults.standard.value(forKey: Safe4CustomTokenManager.safe4DeployContractsKey) as? [String]
    }
}
