import UIKit

final class RepositoryDetailsCoordinator: Coordinator {
    
    enum DeepLink {
        
    }
    
    var rootVC: UIViewController {
        return navigationController
    }
    private var navigationController: NavigationViewController
    private var reposDetailsVC: RepositoryDetailsVC?
    
    private var repository: Repository
    
    init(presenter: NavigationViewController = NavigationViewController(), repository: Repository) {
        self.navigationController = presenter
        self.repository = repository
        super.init()
    }
    
    //MARK: - Actions
    func start(deepLink: RepositoryDetailsCoordinator.DeepLink?) {
        showRepositoryDetails()
    }
    
    private func showRepositoryDetails() {
        let controller = RepositoryDetailsVC(repository: repository)
        navigationController.pushViewController(controller, animated: true)
        reposDetailsVC = controller
    }
}
