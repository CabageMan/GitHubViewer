import Foundation
import UIKit
import OAuthSwift

final class APIClient {
    
    let baseURL: URL
    
    private let callBackURL: URL
    private let oauthSwift: OAuth2Swift
    
    private let accessTokenStorage: AccessTokenStorage
    private(set) var accessToken: AccessToken? {
        didSet { accessTokenDidChange?(accessToken) }
    }
    
    var isLoggedIn: Bool {
        return accessToken != nil
    }
    
    var accessTokenDidChange: ((AccessToken?) -> Void)? = nil
    
    //MARK: - Initializers
    init(environment: Environment, accessTokenStorage: AccessTokenStorage) {
        self.accessTokenStorage = accessTokenStorage
        self.accessToken = accessTokenStorage.fetch()
        self.baseURL = environment.baseURL
        self.oauthSwift = OAuth2Swift(
          consumerKey: "884cfa682f82a396433f",
          consumerSecret: "27f1d947b49b0aa89f6aef99488d301224f5ac61",
          authorizeUrl:   environment.authorizeURLString,
          accessTokenUrl: environment.accessTokenURLString,
          responseType:   "code"
        )
        self.callBackURL = environment.oauthCallBackURL
    }
    
    //MARK: - Actions
    private func setAccessToken(_ token: String) {
        let authToken = AccessToken(token: token)
        accessTokenStorage.store(authToken)
        accessToken = authToken
    }
    
    func showLogin(in vc: UIViewController) {
        oauthSwift.allowMissingStateCheck = true
        oauthSwift.authorizeURLHandler = SafariURLHandler(viewController: vc, oauthSwift: oauthSwift)
        oauthSwift.authorize(withCallbackURL: callBackURL, scope: "", state: "") { [weak self] result in
            switch result {
            case .success(let (credential, response, parameters)):
                self?.setAccessToken(credential.oauthToken)
            case .failure(let error):
                log("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func logout() {
        Global.showComingSoon()
    }
}
