import UIKit

final class IssuesCoordinator: Coordinator {
    
    enum DeepLink {
        
    }
    
    var rootVC: UIViewController {
        return navigationController
    }
    private var navigationController: NavigationViewController
    private var issuesVC: IssuesVC?
    
    init(presenter: NavigationViewController = NavigationViewController()) {
        self.navigationController = presenter
        super.init()
    }
    
    //MARK: - Actions
    func start(deepLink: IssuesCoordinator.DeepLink? = nil) {
        showIssuesVC()
    }
    
    private func showIssuesVC() {
        let controller = IssuesVC()
        navigationController.pushViewController(controller, animated: true)
        issuesVC = controller
    }
    
    func handleSecondTabTap() {
        navigationController.popToRootViewController(animated: true)
    }
}
