import UIKit

final class ProfileCoordinator: Coordinator {
    
    enum DeepLink {
        
    }
    
    var rootVC: UIViewController {
        return navigationController
    }
    private var navigationController: NavigationViewController
    private var profileVC: ProfileVC?
    
    private lazy var repositoriesRouter = RepositoriesRouter(currentCoordinator: self, navigationController: navigationController)
    
    init(presenter: NavigationViewController = NavigationViewController()) {
        self.navigationController = presenter
        super.init()
    }
    
    //MARK: - Actions
    func start(deepLink: ProfileCoordinator.DeepLink? = nil) {
        showProfileVC()
    }
    
    private func showProfileVC() {
        let controller = ProfileVC(router: repositoriesRouter)
        navigationController.pushViewController(controller, animated: true)
        profileVC = controller
    }
    
    func handleSecondTabTap() {
        navigationController.popToRootViewController(animated: true)
    }
}
