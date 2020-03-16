import UIKit

extension UIViewController {
    
    //MARK: - Show Error Alert
    func showErrorAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }
}
