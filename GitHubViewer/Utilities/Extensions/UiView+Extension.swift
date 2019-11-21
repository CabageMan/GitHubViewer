import UIKit

extension UIView {
    func fadeTransition(duration: CFTimeInterval) {
        CATransition().do {
            $0.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            $0.type = CATransitionType.fade
            $0.duration = duration
            layer.add($0, forKey: CATransitionType.fade.rawValue)
        }
    }
}
