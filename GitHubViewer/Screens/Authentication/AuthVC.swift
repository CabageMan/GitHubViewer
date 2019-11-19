import UIKit
import OAuthSwift

final class AuthVC: UIViewController {
    
    let oauthswift = OAuth2Swift(
      consumerKey:    "884cfa682f82a396433f",
      consumerSecret: "27f1d947b49b0aa89f6aef99488d301224f5ac61",
      authorizeUrl:   "https://github.com/login/oauth/authorize",
      accessTokenUrl: "https://github.com/login/oauth/access_token",
      responseType:   "code"
    )
    
    //MARK: - Life ycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupServices()
    }
    
    private func setupUI() {
        view.backgroundColor = .mainBackground
    }
    
    private func setupServices() {
        oauthswift.allowMissingStateCheck = true
        oauthswift.authorizeURLHandler = SafariURLHandler(viewController: self, oauthSwift: oauthswift)

        guard let callBackURL = URL(string: "githubviewer://oauth-callback") else { return }

        oauthswift.authorize(withCallbackURL: callBackURL, scope: "", state: "") { result in
            switch result {
            case .success(let (credential, response, parameters)):
                log("Token: \(credential.oauthToken)")
                log("Refresh token: \(credential.oauthRefreshToken)")
            case .failure(let error):
                log("Error: \(error.localizedDescription)")
            }
        }
    }
}
