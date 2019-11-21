import Foundation
import KeychainAccess

struct AccessTokenStorage: APIAccessTokenStorage {
    
    private let keychain: Keychain
    private let key = "gitHubViewer_creds"
    
    init(_ keychain: Keychain) {
        self.keychain = keychain
    }
    
    func fetch() -> AccessToken? {
        do {
            guard let data = try keychain.getData(key) else { return nil }
            return try? JSONDecoder().decode(AccessToken.self, from: data)
        } catch {
            log("Access token fetch error: \(error.localizedDescription)\n")
            return nil
        }
    }
    
    func store(_ token: AccessToken) {
        do {
            let data = try JSONEncoder().encode(token)
            try keychain.set(data, key: key)
        } catch {
            log("Access token store error: \(error.localizedDescription)\n")
        }
    }
    
    func clear() {
        do {
            try keychain.remove(key)
        } catch {
            log("Access token clear error: \(error.localizedDescription)\n")
        }
    }
}
