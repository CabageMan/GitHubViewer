import UIKit

class BaseRouter: RouterProtocol {
    var currentCoordinator: BaseCoordinator?
    var navigationController: UINavigationController?
    
    required init(currentCoordinator: BaseCoordinator, navigationController: UINavigationController) {
        self.currentCoordinator = currentCoordinator
        self.navigationController = navigationController
    }
}

final class RepositoriesRouter: BaseRouter {
    //TODO: Imlement RepositoriesFlow navigation
}
