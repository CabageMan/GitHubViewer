import UIKit

final class AuthNavigationViewController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .mainBackground
        navigationBar.do {
            $0.isTranslucent = false
            $0.tintColor = .white
            $0.shadowImage = UIImage()
            $0.barTintColor = .barBlack
        }
        delegate = self
    }
}

//MARK: - Navigation Controller Delegate
extension AuthNavigationViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
      let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
      viewController.navigationItem.backBarButtonItem = item
      setNavigationBarHidden(true, animated: animated)
    }
}
