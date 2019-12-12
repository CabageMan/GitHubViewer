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
    func showSetiings() {
        let settingsController = SettingsController()
        navigationController?.pushViewController(settingsController)
    }
}
