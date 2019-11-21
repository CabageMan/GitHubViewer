import UIKit

final class AuthCoordinator: Coordinator {
    enum DeepLink {
        case onboarding
        case authScreen
    }
    
    enum AuthResult {
        case success
        case failure
    }
    
    var userDidLogin: (AuthResult) -> Void = { _ in }
    
    private let navigationController: AuthNavigationViewController
    
    init(navigationController: AuthNavigationViewController) {
        self.navigationController = navigationController
        super.init()
    }
    
    func start(deepLink: AuthCoordinator.DeepLink? = nil) {
        let deepLink = deepLink ?? (Global.isOnboardingComplete ? .authScreen : .onboarding)
        switch deepLink {
        case .onboarding:
            let onboardingVC = IntroVC()
            onboardingVC.completion = { [weak self] in
                Global.isOnboardingComplete = true
                self?.showAuth()
            }
            navigationController.viewControllers = [onboardingVC]
        case .authScreen:
            navigationController.viewControllers = [createAuthVC()]
        }
    }
    
    private func showAuth() {
        navigationController.pushViewController(createAuthVC(), animated: true)
    }
    
    private func createAuthVC() -> UIViewController {
        let authVC = AuthVC()
        authVC.userDidLogin = userDidLogin
        return authVC
    }
}
