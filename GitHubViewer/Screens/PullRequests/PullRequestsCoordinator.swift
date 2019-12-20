import UIKit

final class PullRequestsCoordinator: Coordinator {
    
    enum DeepLink {
        
    }
    
    var rootVC: UIViewController {
        return navigationController
    }
    private var navigationController: NavigationViewController
    private var prVC: PullRequestsVC?
    
    private lazy var repositoriesRouter = RepositoriesRouter(currentCoordinator: self, navigationController: navigationController)
    
    init(presenter: NavigationViewController = NavigationViewController()) {
        self.navigationController = presenter
        super.init()
    }
    
    //MARK: - Actions
    func start(deepLink: PullRequestsCoordinator.DeepLink? = nil) {
        showPRVC()
    }
    
    private func showPRVC() {
        let controller = PullRequestsVC(router: repositoriesRouter)
        navigationController.pushViewController(controller, animated: true)
        prVC = controller
    }
    
    func handleSecondTabTap() {
        navigationController.popToRootViewController(animated: true)
    }
}
