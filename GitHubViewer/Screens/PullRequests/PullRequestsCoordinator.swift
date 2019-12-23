import UIKit
import Parchment

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
        let createdRequestsVC = PullRequestsCollectionVC(router: repositoriesRouter, mode: .created)
        let assignedRequestsVC = PullRequestsCollectionVC(router: repositoriesRouter, mode: .assigned)
        let mentionedRequestsVC = PullRequestsCollectionVC(router: repositoriesRouter, mode: .mentioned)
        let reviewRequestsVC = PullRequestsCollectionVC(router: repositoriesRouter, mode: .reviewRequests)
        let pageController = FixedPagingViewController(
            viewControllers: [
                createdRequestsVC,
                assignedRequestsVC,
                mentionedRequestsVC,
                reviewRequestsVC
            ]
        )
        
        let controller = PullRequestsVC(router: repositoriesRouter, pagingController: pageController)
        navigationController.pushViewController(controller, animated: true)
        prVC = controller
    }
    
    func handleSecondTabTap() {
        navigationController.popToRootViewController(animated: true)
    }
}
