import UIKit
@_exported import TinyConstraints

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var window: UIWindow? = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .white
        return window
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let nc = UINavigationController(rootViewController: AuthVC())
        nc.isNavigationBarHidden = true
        window?.rootViewController = nc
        window?.makeKeyAndVisible()
        
        return true
    }
}

