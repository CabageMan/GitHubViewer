import UIKit
import KeychainAccess

struct Global {
    //MARK: - Static Properties
    static var environment: Environment = .staging
    
    static let apiClient = createAPICLient(environment: Global.environment)
    
    static var isOnboardingComplete: Bool {
        get { return Storage.getValue(for: .isOnboardingComplete) ?? false }
        set { Storage.set(value: newValue, for: .isOnboardingComplete) }
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
    
    //MARK: - Error Handling
    static func handle(error: Error) {
//        guard !apiClient.isLoggingOut else { return }
//        apiClient.isLoggingOut = true
//        var errorMessage: String?
//        var completion: (() -> Void)?
//
//        switch error {
//        case is APIErrors.UnauthorizedError:
//            errorMessage = (error as? APIErrors.UnauthorizedError)?.message
//            completion = { Global.apiClient.logout() }
//        case is APIErrors.UndefinedError:
//            errorMessage = (error as? APIErrors.UndefinedError)?.message
//        case is APIErrors.ConnectionLockedByTimeout:
//            errorMessage = (error as? APIErrors.ConnectionLockedByTimeout)?.message
//        case is APIErrors.ConnectionBlockedByUser:
//            errorMessage = (error as? APIErrors.ConnectionBlockedByUser)?.message
//        case is ParsedAPIError:
//            errorMessage = (error as? ParsedAPIError)?.message
//        default:
//            errorMessage = String.Error.somethingWrong
//        }
//
//        let message = errorMessage ?? String.Error.somethingWrong
//        UIViewController.current?.showErrorAlert(title: String.General.oops, message: message) { _ in
//            completion?()
//        }
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
