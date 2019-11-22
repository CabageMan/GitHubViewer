import UIKit

final class PRCoordinator: Coordinator {
    
    enum DeepLink {
        
    }
    
    var rootVC: UIViewController {
        return navigationController
    }
    private var navigationController: NavigationViewController
    private var prVC: PRVC?
    
    // Here we can set routers
    
    init(presenter: NavigationViewController = NavigationViewController()) {
        self.navigationController = presenter
        super.init()
    }
    
    //MARK: - Actions
    func start(deepLink: PRCoordinator.DeepLink? = nil) {
        showPRVC()
    }
    
    private func showPRVC() {
        let controller = PRVC()
        navigationController.pushViewController(controller, animated: true)
        prVC = controller
    }
    
    func handleSecondTabTap() {
        navigationController.popToRootViewController(animated: true)
    }
}
