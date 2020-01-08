import UIKit

final class PullRequestsCoordinator: Coordinator {
    
    enum DeepLink {
        
    }
    
    var rootVC: UIViewController {
        return navigationController
    }
    private var navigationController: NavigationViewController
    private var pullRequestVC: PullRequestsVC?
    
    private lazy var repositoriesRouter = RepositoriesRouter(currentCoordinator: self, navigationController: navigationController)
    
    init(presenter: NavigationViewController = NavigationViewController()) {
        self.navigationController = presenter
        super.init()
    }
    
    //MARK: - Actions
    func start(deepLink: PullRequestsCoordinator.DeepLink? = nil) {
        showPullRequestVC()
    }
    
    private func showPullRequestVC() {
        let controller = PullRequestsVC(router: repositoriesRouter, currentPage: .created)
        navigationController.pushViewController(controller, animated: true)
        pullRequestVC = controller
    }
    
    func handleSecondTabTap() {
        navigationController.popToRootViewController(animated: true)
    }
}
