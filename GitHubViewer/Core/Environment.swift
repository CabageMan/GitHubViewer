import Foundation

enum Environment: String {
    case staging
    case production
    
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
        return URL(string: "githubviewer://oauth-callback")!
    }
    
    private var baseURLString: String {
        switch self {
        case .staging: return "https://api.github.com"
        case .production: return "https://api.github.com"
        }
    }
}
