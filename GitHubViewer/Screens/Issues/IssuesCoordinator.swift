import UIKit

final class IssuesCoordinator: Coordinator {
    
    enum DeepLink {
        
    }
    
    var rootVC: UIViewController {
        return navigationController
    }
    private var navigationController: NavigationViewController
    private var issuesVC: IssuesVC?
    
    private lazy var router = GithubViewerRouter(currentCoordinator: self, navigationController: navigationController)
    
    init(presenter: NavigationViewController = NavigationViewController()) {
        self.navigationController = presenter
        super.init()
    }
    
    //MARK: - Actions
    func start(deepLink: IssuesCoordinator.DeepLink? = nil) {
        showIssuesVC()
    }
    
    private func showIssuesVC() {
        let controller = IssuesVC(router: router, currentPage: .created)
        navigationController.pushViewController(controller, animated: true)
        issuesVC = controller
    }
    
    func handleSecondTabTap() {
        navigationController.popToRootViewController(animated: true)
    }
}
