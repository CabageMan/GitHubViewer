import Foundation
import UIKit
import OAuthSwift

final class APIClient {
    
    let baseURL: URL
    
    private let callBackURL: URL
    private let oauthSwift: OAuth2Swift
    private let scope: String
    
    private let accessTokenStorage: AccessTokenStorage
    private(set) var accessToken: AccessToken? {
        didSet { accessTokenDidChange?(accessToken) }
    }
    
    var ownUser: User? {
        didSet { ownUserDidChange?() }
    }
    
    var isLoggedIn: Bool {
        #warning("Add checking for actual token")
        return accessToken != nil
    }
    
    let loggedOutSignal = Signal<Void>()
    
    let syncDispatchQueue = DispatchQueue(label: "Sync Queue", qos: .userInitiated)
    
    var accessTokenDidChange: ((AccessToken?) -> Void)? = nil
    var ownUserDidChange: (() -> Void)? = nil
    
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
        self.scope = environment.authScope
    }
    
    //MARK: - Actions
    private func setAccessToken(_ token: String) {
        let authToken = AccessToken(token: token)
        accessTokenStorage.store(authToken)
        accessToken = authToken
    }
    
    func removeAccessToken() {
        accessTokenStorage.clear()
        accessToken = nil
    }
    
    func showLogin(in vc: UIViewController) {
        oauthSwift.allowMissingStateCheck = true
        oauthSwift.authorizeURLHandler = SafariURLHandler(viewController: vc, oauthSwift: oauthSwift)
        oauthSwift.authorize(withCallbackURL: callBackURL, scope: scope, state: generateState(withLength: 20)) { [weak self, weak vc] result in
            guard let authVC = vc as? AuthVC else { return }
            switch result {
            case .success(let (credential, _, _)):
                self?.setAccessToken(credential.oauthToken)
                authVC.userDidLogin(.success)
            case .failure(let error):
                authVC.userDidLogin(.failure)
                log("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func showLogin(with handler: OAuthSwiftURLHandlerType, completion: @escaping (Bool) -> Void) {
        oauthSwift.allowMissingStateCheck = true
        oauthSwift.authorizeURLHandler = handler
        oauthSwift.authorize(withCallbackURL: callBackURL, scope: scope, state: generateState(withLength: 20)) { [weak self] result in
            switch result {
            case .success(let (credential, _, _)):
                self?.setAccessToken(credential.oauthToken)
                completion(true)
            case .failure(let error):
                completion(false)
                log("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func cancelAuthRequest() {
        oauthSwift.cancel()
    }
    
    func logout() {
        Spinner.start()
        WebViewController.clean { [weak self] in
            self?.syncDispatchQueue.async { [weak self] in self?.handleLogout() }
        }
    }
    
    private func handleLogout() {
        dispatchPrecondition(condition: .onQueue(syncDispatchQueue))
        guard accessToken != nil else { return }
        accessTokenStorage.clear()
        accessToken = nil
        ownUser = nil
        loggedOutSignal.fire(())
    }
    
    private func generateState(withLength len: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let length = UInt32(letters.count)

        var randomString = ""
        for _ in 0..<len {
            let rand = arc4random_uniform(length)
            let idx = letters.index(letters.startIndex, offsetBy: Int(rand))
            let letter = letters[idx]
            randomString += String(letter)
        }
        return randomString
    }
}
