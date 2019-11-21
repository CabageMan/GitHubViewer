import UIKit

protocol RouterProtocol {
    var currentCoordinator: BaseCoordinator? { get }
    var navigationController: UINavigationController? { get }
    
    init(currentCoordinator: BaseCoordinator, navigationController: UINavigationController)
}
