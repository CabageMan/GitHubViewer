import UIKit

extension UIStackView {
    func addSpace(height: CGFloat) {
        UIView().add(to: self).do {
            $0.height(height)
            $0.backgroundColor = .clear
        }
    }
}
