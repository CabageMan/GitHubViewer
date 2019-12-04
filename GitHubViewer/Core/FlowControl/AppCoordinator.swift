import UIKit

final class AppCoordinator: Coordinator {
    enum DeepLink {
        case auth(AuthCoordinator.DeepLink?)
        case tabs(TabBarCoordinator.DeepLink?)
    }
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        super.init()
        #warning("Need to implement logut functionality. Need to learn about better implementation")
    }
    
    //MARK: - Actions
    func start(deepLink: DeepLink? = nil) {
        let deepLink = deepLink ?? (Global.apiClient.isLoggedIn ? .tabs(nil) : .auth(nil))
        
        switch deepLink {
        case .auth(let deepLink):
            runAuthFlow(deepLink)
        case .tabs(let deepLink):
            runTabsFlow(deepLink)
        }
    }
    
    private func runAuthFlow(_ deepLink: AuthCoordinator.DeepLink? = nil) {
        let navigationController = AuthNavigationViewController()
        window.switchRootViewController(navigationController)
        window.makeKeyAndVisible()
        
        let coordinator = AuthCoordinator(navigationController: navigationController)
        coordinator.userDidLogin = checkAuth(coordinator: coordinator)
        addChild(coordinator)
        coordinator.start(deepLink: deepLink)
    }
    
    private func runTabsFlow(_ deepLink: TabBarCoordinator.DeepLink? = nil) {
        let coordinator = TabBarCoordinator(window: window)
        addChild(coordinator)
        coordinator.start(deepLink: deepLink)
    }
    
    private func checkAuth(coordinator: AuthCoordinator) -> ((AuthCoordinator.AuthResult) -> Void) {
        return { [weak self, weak coordinator] authResult in
            guard let self = self else { return }
            if let authCoordinator = coordinator { self.removeChild(authCoordinator) }
            switch authResult {
            case .success:
                self.runTabsFlow()
            case .failure:
                Global.apiClient.removeAccessToken()
                self.runAuthFlow()
            }
        }
    }
}


