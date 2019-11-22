import UIKit

final class ReposCoordinator: Coordinator {
    
    enum DeepLink {
        
    }
    
    var rootVC: UIViewController {
        return navigationController
    }
    private var navigationController: NavigationViewController
    private var reposVC: ReposVC?
    
    // Here we can set routers
    
    init(presenter: NavigationViewController = NavigationViewController()) {
        self.navigationController = presenter
        super.init()
    }
    
    //MARK: - Actions
    func start(deepLink: ReposCoordinator.DeepLink? = nil) {
        showReposVC()
    }
    
    private func showReposVC() {
        let controller = ReposVC()
        navigationController.pushViewController(controller, animated: true)
        reposVC = controller
    }
    
    func handleSecondTabTap() {
        navigationController.popToRootViewController(animated: true)
    }
}
