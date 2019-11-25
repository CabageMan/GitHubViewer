import UIKit

final class ReposDetailsCoordinator: Coordinator {
    
    enum DeepLink {
        
    }
    
    var rootVC: UIViewController {
        return navigationController
    }
    private var navigationController: NavigationViewController
    private var reposDetailsVC: ReposDetailsVC?
    
    private var repository: Repository
    
    init(presenter: NavigationViewController = NavigationViewController(), repository: Repository) {
        self.navigationController = presenter
        self.repository = repository
        super.init()
    }
    
    //MARK: - Actions
    func start(deepLink: ReposDetailsCoordinator.DeepLink?) {
        showRepositoryDetails()
    }
    
    private func showRepositoryDetails() {
        let controller = ReposDetailsVC(repository: repository)
        navigationController.pushViewController(controller, animated: true)
        reposDetailsVC = controller
    }
}
