import UIKit

final class NavigationViewController: UINavigationController {
    var isPopedToRoot = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .mainBackground
        navigationBar.do {
            $0.isTranslucent = false
            $0.shadowImage = UIImage()
            $0.tintColor = .white
            $0.barTintColor = .barBlack
            $0.titleTextAttributes = [.foregroundColor: UIColor.white]
        }
        delegate = self
    }
    #warning("Check if we need to deinit, and check popped to root. It was in Hangs code review.")
    deinit {
        delegate = nil
    }
    
    func popToRootViewController(animated: Bool = true, completion: (() -> Void)? = nil) {
        isPopedToRoot = true
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: true)
        CATransaction.commit()
    }
}

//MARK: - Navigation Controller Delegate
extension NavigationViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.navigationController?.addCustomTransitioning()
    }
}
