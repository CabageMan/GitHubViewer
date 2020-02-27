import UIKit

//MARK: -Array Extensions
extension Array {
    func safeValue(at index: Int) -> Element? {
        return index < self.count ? self[index] : nil
    }
}

//MARK: -UIBezierPath Extensions
extension UIBezierPath {
    convenience init(lineSegment: LineSegment) {
        self.init()
        self.move(to: lineSegment.startPoint)
        self.addLine(to: lineSegment.endPoint)
    }
}

//MARK: -CALayer Extensions
extension CALayer {
    func addLineLayer(lineSegment: LineSegment, oldSegment: LineSegment?, color: CGColor, width: CGFloat, isDashed: Bool, animated: Bool) {
        let layer = CAShapeLayer().then {
            $0.path = UIBezierPath(lineSegment: lineSegment).cgPath
            $0.fillColor = UIColor.clear.cgColor
            $0.strokeColor = color
            $0.lineWidth = width
            if isDashed {
                $0.lineDashPattern = [4, 4]
            }
            self.addSublayer($0)
        }
        
        if animated, let previousSegment = oldSegment {
            layer.animate(
                fromValue: UIBezierPath(lineSegment: previousSegment).cgPath,
                toValue: layer.path!,
                keyPath: "path"
            )
        }
    }
    
    func addRectangleLayer(frame: CGRect, oldFrame: CGRect?, startColor: CGColor, endColor: CGColor, animated: Bool) {
        
        let gradientLayer = CAGradientLayer().then {
            $0.frame = frame
            $0.colors = [startColor, endColor]
            self.addSublayer($0)
        }
        
        if animated, let previousFrame = oldFrame {
            gradientLayer.animate(
                fromValue: CGPoint(x: previousFrame.midX, y: previousFrame.midY),
                toValue: gradientLayer.position,
                keyPath: "position"
            )
            gradientLayer.animate(
                fromValue: CGRect(x: 0.0, y: 0.0, width: previousFrame.width, height: previousFrame.height),
                toValue: gradientLayer.bounds,
                keyPath: "bounds"
            )
        }
    }
    
    func addTextLayer(frame: CGRect, oldFrame: CGRect?, color: CGColor, fontSize: CGFloat, text: String, animated: Bool) {
        let layer = CATextLayer().then {
            $0.frame = frame
            $0.foregroundColor = color
            $0.backgroundColor = UIColor.clear.cgColor
            $0.alignmentMode = .center
            $0.contentsScale = UIScreen.main.scale
            $0.font = CTFontCreateWithName(UIFont.circular(style: .book, size: 0).fontName as CFString, 0, nil)
            $0.fontSize = fontSize
            $0.string = text
            self.addSublayer($0)
        }
        
        if animated, let previousFrame = oldFrame {
            let oldPosition = CGPoint(x: previousFrame.midX, y: previousFrame.midY)
            layer.animate(fromValue: oldPosition, toValue: layer.position, keyPath: "position")
        }
    }
    
    func animate(fromValue: Any, toValue: Any, keyPath: String) {
        CABasicAnimation(keyPath: keyPath).do {
            $0.fromValue = fromValue
            $0.toValue = toValue
            $0.duration = 0.5
            $0.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            self.add($0, forKey: keyPath)
        }
    }
}
