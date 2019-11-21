import UIKit

final class TabBarCoordinator: Coordinator {
    
    enum DeepLink {
        
    }
    
    let tabBarViewController = TabBarViewController()
    private let window: UIWindow
    
    // Coordinators
    
    init(window: UIWindow) {
        self.window = window
        
        super.init()
        log("Init Tab Bar coordinator")
    }
    
    //MARK: - Actions
    func start(deepLink: TabBarCoordinator.DeepLink? = nil) {
        log("Start Tab Bar Coordinator")
    }
    
}
