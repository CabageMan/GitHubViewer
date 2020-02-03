import UIKit

class BaseRouter: RouterProtocol {
    weak var currentCoordinator: BaseCoordinator?
    weak var navigationController: UINavigationController?
    
    required init(currentCoordinator: BaseCoordinator, navigationController: UINavigationController) {
        self.currentCoordinator = currentCoordinator
        self.navigationController = navigationController
    }
}

final class GithubViewerRouter: BaseRouter {
    func showMenu() {
        let settingsController = SideMenuController(router: self)
        navigationController?.pushViewController(settingsController)
    }
    
    func showPullRequestDetails(pullRequest: PullRequest) {
        let pullRequestDetailsController = PullRequestDetailsVC(router: self, pullRequest: pullRequest)
        navigationController?.pushViewController(pullRequestDetailsController)
    }
    
    func showIssueDetails(issue: Issue) {
        let issueDetailsController = IssueDetailsVC(router: self, issue: issue)
        navigationController?.pushViewController(issueDetailsController)
    }
}
