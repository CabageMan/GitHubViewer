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

// Temporary soluton for bug with action sheet constraint error
// https://stackoverflow.com/questions/55653187/swift-default-alertviewcontroller-breaking-constraints
// https://stackoverflow.com/questions/55372093/uialertcontrollers-actionsheet-gives-constraint-error-on-ios-12-2-12-3
extension UIAlertController {
    func pruneNegativeWidthConstraints() {
        for subView in self.view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
}
