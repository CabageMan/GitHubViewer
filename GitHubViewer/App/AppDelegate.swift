import UIKit
import Nuke
import OAuthSwift
@_exported import TinyConstraints

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var window: UIWindow?
    
    private lazy var appCoordinator: AppCoordinator = {
        return AppCoordinator(window: window!)
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds).then {
            $0.backgroundColor = .mainBackground
        }
        
        appCoordinator.start()
        
        imageCashingSetup()
        
        return true
    }
    
    func imageCashingSetup() {
        ImageCache.shared.costLimit = 1024 * 1024 * 256 // 256 Mb
        ImageCache.shared.countLimit = 250
        ImageCache.shared.ttl = 0 // Invalidate after 'never'
        
        DataLoader.sharedUrlCache.diskCapacity = 1024 * 1024 * 256
        DataLoader.sharedUrlCache.memoryCapacity = 1024 * 1024 * 256
    }
}

//MARK: - OAuth Implementation
extension AppDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey  : Any] = [:]) -> Bool {
        applicationHandle(url: url)
        return true
    }
    
    func applicationHandle(url: URL) {
        if (url.host == Environment.oauthCallback) {
            OAuthSwift.handle(url: url)
        }
    }
}

