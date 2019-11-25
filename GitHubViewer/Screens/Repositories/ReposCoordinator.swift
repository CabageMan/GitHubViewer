import UIKit

final class ReposCoordinator: Coordinator {
    
    enum DeepLink {
        
    }
    
    var rootVC: UIViewController {
        return navigationController
    }
    private var navigationController: NavigationViewController
    private var reposVC: ReposVC?
    
    private var reposDetailsCoordinator: ReposDetailsCoordinator?
    
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
        controller.onReposCellTap = { [weak self] repository in
            self?.runRepositoryDetailsFlow(repository: repository)
        }
        navigationController.pushViewController(controller, animated: true)
        reposVC = controller
    }
    
    private func runRepositoryDetailsFlow(deepLink: ReposDetailsCoordinator.DeepLink? = nil, repository: Repository) {
        let coordinator = ReposDetailsCoordinator(presenter: navigationController, repository: repository)
        coordinator.start(deepLink: deepLink)
        reposDetailsCoordinator = coordinator
    }
    
    func handleSecondTabTap() {
        navigationController.popToRootViewController(animated: true)
    }
}
