import UIKit
import OAuthSwift

final class AuthVC: UIViewController {
    
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
        guard !Global.apiClient.isLoggedIn else {
            Global.showCustomMessage(message: "We are successfully logged in")
            return
        }
        Global.apiClient.showLogin(in: self)
    }
}
