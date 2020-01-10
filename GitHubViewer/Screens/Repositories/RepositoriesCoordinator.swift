import UIKit

final class RepositoriesCoordinator: Coordinator {
    
    enum DeepLink {
        
    }
    
    var rootVC: UIViewController {
        return navigationController
    }
    private var navigationController: NavigationViewController
    private var reposVC: RepositoriesVC?
    
    private var reposDetailsCoordinator: RepositoryDetailsCoordinator?
    
    private lazy var router = GithubViewerRouter(currentCoordinator: self, navigationController: navigationController)
    
    init(presenter: NavigationViewController = NavigationViewController()) {
        self.navigationController = presenter
        super.init()
    }
    
    //MARK: - Actions
    func start(deepLink: RepositoriesCoordinator.DeepLink? = nil) {
        showReposVC()
    }
    
    private func showReposVC() {
        let controller = RepositoriesVC(router: router)
        controller.onReposCellTap = { [weak self] repository in
            self?.runRepositoryDetailsFlow(repository: repository)
        }
        navigationController.pushViewController(controller, animated: true)
        reposVC = controller
    }
    
    private func runRepositoryDetailsFlow(deepLink: RepositoryDetailsCoordinator.DeepLink? = nil, repository: Repository) {
        removeAllChildren()
        guard let ownUser = Global.apiClient.ownUser else { return }
        let coordinator = RepositoryDetailsCoordinator(presenter: navigationController, owner: ownUser.login, repository: repository)
        coordinator.start(deepLink: deepLink)
        reposDetailsCoordinator = coordinator
        addChild(coordinator)
    }
    
    func handleSecondTabTap() {
        navigationController.popToRootViewController(animated: true)
    }
}
