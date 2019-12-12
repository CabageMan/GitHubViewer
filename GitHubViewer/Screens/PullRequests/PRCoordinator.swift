import UIKit

final class PRCoordinator: Coordinator {
    
    enum DeepLink {
        
    }
    
    var rootVC: UIViewController {
        return navigationController
    }
    private var navigationController: NavigationViewController
    private var prVC: PRVC?
    
    private lazy var repositoriesRouter = RepositoriesRouter(currentCoordinator: self, navigationController: navigationController)
    
    init(presenter: NavigationViewController = NavigationViewController()) {
        self.navigationController = presenter
        super.init()
    }
    
    //MARK: - Actions
    func start(deepLink: PRCoordinator.DeepLink? = nil) {
        showPRVC()
    }
    
    private func showPRVC() {
        let controller = PRVC(router: repositoriesRouter)
        navigationController.pushViewController(controller, animated: true)
        prVC = controller
    }
    
    func handleSecondTabTap() {
        navigationController.popToRootViewController(animated: true)
    }
}
