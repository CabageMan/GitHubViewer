import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        let nc = UINavigationController(rootViewController: HomeVC())
        let vc = IntroVC()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        return true
    }
}

