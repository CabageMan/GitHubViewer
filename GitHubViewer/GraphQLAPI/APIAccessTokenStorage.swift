import Foundation

protocol APIAccessTokenStorage {
    func fetch() -> AccessToken?
    func store(_ token: AccessToken)
    func clear()
}

struct AccessToken: Codable {
    let token: String
    
    init(token: String) {
        self.token = token
    }
}
