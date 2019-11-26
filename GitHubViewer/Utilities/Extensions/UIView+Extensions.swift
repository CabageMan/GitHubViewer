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
    
    func setRoundedMask(radius: CGFloat) {
        let maskImageView = UIImageView().then {
            $0.image = DrawFigure.circle(radius: radius, strokeColor: .black, strokeWidth: 1, fillColor: .black)
            $0.frame = CGRect(origin: .zero, size: CGSize(width: radius * 2, height: radius * 2))
        }
        self.mask = maskImageView
    }
    
    func dropShadow() {
        self.layer.do {
            $0.shadowColor = UIColor.black.cgColor
            $0.shadowOpacity = 0.6
            $0.shadowRadius = 5
            $0.shadowOffset = CGSize(width: 0, height: 6)
        }
    }
}
