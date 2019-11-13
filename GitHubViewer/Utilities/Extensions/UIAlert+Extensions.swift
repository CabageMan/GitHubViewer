import UIKit

extension UIAlertAction {
    static func ok(_ action: (() -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(
            title: String.General.ok,
            style: .default,
            handler: action.map { block in { _ in block() } }
        )
    }
    
    static func cancel(_ action: (() -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(
            title: String.General.cancel,
            style: .cancel,
            handler: action.map { block in { _ in block() } }
        )
    }
}
