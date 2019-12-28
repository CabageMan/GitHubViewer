import UIKit

class BaseRouter: RouterProtocol {
    weak var currentCoordinator: BaseCoordinator?
    weak var navigationController: UINavigationController?
    
    required init(currentCoordinator: BaseCoordinator, navigationController: UINavigationController) {
        self.currentCoordinator = currentCoordinator
        self.navigationController = navigationController
    }
}

final class RepositoriesRouter: BaseRouter {
    func showMenu() {
        let settingsController = SideMenuController(router: self)
        navigationController?.pushViewController(settingsController)
    }
    
    func showPullRequestDetails(pullRequest: PullRequest) {
        let detailsController = PullRequestDetails(router: self, pullRequest: pullRequest)
        navigationController?.pushViewController(detailsController)
    }
}
