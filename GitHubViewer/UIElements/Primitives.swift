import UIKit

private let imagesCache = NSCache<NSString, UIImage>().then {
    $0.name = "Generated Images Cache"
}

struct DrawFigure {
    
    static func roundedRect(radius: CGFloat, color: UIColor, fillColor: UIColor? = nil, strokeWidth: CGFloat = 1) -> UIImage {
        let key = "roundedBackground_\(radius)_\(color)_\(fillColor ?? UIColor.clear)_\(strokeWidth)" as NSString
        if let cached = imagesCache.object(forKey: key) {
            return cached
        }
        
        let size = CGSize(radius * 2 + 1)
        let image = UIGraphicsImageRenderer(size: size).image { context in
            let path = UIBezierPath(
                roundedRect: size.asRect.insetBy(dx: 0.5, dy: 0.5),
                cornerRadius: radius
            )
            path.lineWidth = strokeWidth
            color.setStroke()
            if let fillColor = fillColor {
                fillColor.setFill()
                path.fill()
            }
            path.stroke()
        }
        
        let resizableImage = image.resizableImage(withCapInsets: UIEdgeInsets(value: radius), resizingMode: .stretch)
        
        imagesCache.setObject(resizableImage, forKey: key)
        return resizableImage
    }
    
    static func circle(radius: CGFloat, strokeColor: UIColor, strokeWidth: CGFloat, fillColor: UIColor) -> UIImage {
        let key = "circle\(radius)_\(strokeColor)_\(fillColor)_\(strokeWidth)"  as NSString
        if let cached = imagesCache.object(forKey: key) {
            return cached
        }
        
        let size = CGSize(width: radius * 2, height: radius * 2)
        let image = UIGraphicsImageRenderer(size: size).image { context in
            let path = UIBezierPath(
                roundedRect: size.asRect.insetBy(dx: 0.5, dy: 0.5),
                cornerRadius: radius
            )
            path.lineWidth = strokeWidth
            strokeColor.setStroke()
            fillColor.setFill()
            path.fill()
            path.stroke()
        }
        
        return image
    }
}
