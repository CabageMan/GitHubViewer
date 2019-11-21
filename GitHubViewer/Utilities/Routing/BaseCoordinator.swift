import Foundation

typealias Coordinator = BaseCoordinator & DeepLinkStarter

protocol DeepLinkStarter {
    associatedtype DeepLink
    func start(deepLink: DeepLink?)
}

class BaseCoordinator {
    private(set) lazy var identifier = String(describing: type(of: self))
    private var children: [String: BaseCoordinator] = [ : ]
    private weak var parent: BaseCoordinator?
    
    //MARK: - Actions
    func addChild(_ coordinator: BaseCoordinator) {
        assert(children[coordinator.identifier] == nil, "Coordinator with same identifier already exist.")
        children[coordinator.identifier] = coordinator
        coordinator.parent = self
    }
    
    func removeChild(_ coordinator: BaseCoordinator) {
        assert(coordinator.parent === self, "Trying to remove child from other parent")
        children[coordinator.identifier] = nil
        coordinator.parent = nil
    }
    
    func removeFromParent() {
        parent?.removeChild(self)
    }
    
    func removeAllChildren() {
        children.values.forEach { $0.removeFromParent() }
        children = [ : ]
    }
    
    func findParent<T: BaseCoordinator>() -> T? {
        var coordinator: BaseCoordinator? = self
        while coordinator != nil {
            if let coordinator = coordinator?.parent as? T {
                return coordinator
            } else {
                coordinator = coordinator?.parent
            }
        }
        return nil
    }
}
