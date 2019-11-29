import UIKit
import OAuthSwift
@_exported import TinyConstraints

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    #warning("Fix this: UIWindows were created prior to initial application activation. This may result in incorrect visual appearance.")
    var window: UIWindow? = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .white
        return window
    }()
    
    private lazy var appCoordinator: AppCoordinator = {
        return AppCoordinator(window: window!)
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        let nc = UINavigationController(rootViewController: AuthVC())
//        nc.isNavigationBarHidden = true
//        window?.rootViewController = nc
//        window?.makeKeyAndVisible()
        appCoordinator.start()
        
        return true
    }
}

//MARK: - OAuth Implementation
extension AppDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey  : Any] = [:]) -> Bool {
      if (url.host == "oauth-callback") {
        OAuthSwift.handle(url: url)
      }
      return true
    }
}

