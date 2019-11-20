import UIKit
import KeychainAccess

struct Global {
    //MARK: - Static Properties
    static var environment: Environment = .staging
    
    static let apiClient = createAPICLient(environment: Global.environment)
    
    static var isOnboardingComplete: Bool {
        get { return false }
        set {  }
    }
    
    static private func createAPICLient(environment: Environment) -> APIClient {
        let keyChain = Keychain(service: environment.baseURL.absoluteString)
        return APIClient(environment: environment, accessTokenStorage: AccessTokenStorage(keyChain))
    }
    
    //MARK: - Alert Messages
    static func showCustomMessage(message: String) {
      let alert = UIAlertController(title: "🔥", message: message, preferredStyle: .alert)
      alert.addAction(.ok())
      UIViewController.current?.present(alert, animated: true, completion: nil)
    }
    
    static func showComingSoon() {
        let alert = UIAlertController(title: "🔥", message: String.General.comingSoon, preferredStyle: .alert)
        alert.addAction(.ok())
        UIViewController.current?.present(alert, animated: true, completion: nil)
    }
}

//MARK: - Logging
func log(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        Swift.print(formatter.string(from: Date()), " -- ", items[0], separator: separator, terminator: terminator)
    #endif
}
