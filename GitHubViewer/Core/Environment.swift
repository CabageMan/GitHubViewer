import Foundation

enum Environment: String {
    case staging
    case production
    
    static let oauthCallback: String = "oauth-callback"
    static let scheme: String = "githubviewer"
    
    var toggled: Environment {
        switch self {
        case .staging: return .production
        case .production: return .staging
        }
    }
    
    var baseURL: URL {
        return URL(string: baseURLString + "/graphql")!
    }
    
    var authorizeURLString: String {
        return "https://github.com/login/oauth/authorize"
    }
    
    var accessTokenURLString: String {
        return "https://github.com/login/oauth/access_token"
    }
    
    var oauthCallBackURL: URL {
        return URL(string: "\(Environment.scheme)://\(Environment.oauthCallback)/github")!
    }
    
    var authScope: String {
        return "repo"
    }
    
    private var baseURLString: String {
        switch self {
        case .staging: return "https://api.github.com"
        case .production: return "https://api.github.com"
        }
    }
}
