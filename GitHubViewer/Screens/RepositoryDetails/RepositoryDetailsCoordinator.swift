import UIKit

final class RepositoryDetailsCoordinator: Coordinator {
    
    enum DeepLink {
        
    }
    
    var rootVC: UIViewController {
        return navigationController
    }
    private var navigationController: NavigationViewController
    private var reposDetailsVC: RepositoryDetailsVC?
    
    private var repositoryOwnerLogin: String
    private var repository: Repository
    
    private lazy var router = GithubViewerRouter(currentCoordinator: self, navigationController: navigationController)
    
    init(presenter: NavigationViewController = NavigationViewController(), owner: String, repository: Repository) {
        self.navigationController = presenter
        self.repositoryOwnerLogin = owner
        self.repository = repository
        super.init()
    }
    
    //MARK: - Actions
    func start(deepLink: RepositoryDetailsCoordinator.DeepLink?) {
        showRepositoryDetails()
    }
    
    private func showRepositoryDetails() {
        let controller = RepositoryDetailsVC(ownerLogin: repositoryOwnerLogin, repository: repository, router: router)
        controller.onBackButtonTap = { [weak self] in
            controller.dismiss()
            self?.removeFromParent()
        }
        navigationController.pushViewController(controller, animated: true)
        reposDetailsVC = controller
    }
}
