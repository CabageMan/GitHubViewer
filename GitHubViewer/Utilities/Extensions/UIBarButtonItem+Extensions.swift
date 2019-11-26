import UIKit

extension UIBarButtonItem {
    
    static func back(action: @escaping () -> Void) -> UIBarButtonItem {
        let image: UIImage = #imageLiteral(resourceName: "back20").withRenderingMode(.alwaysTemplate)
        let button = UIButton(type: .system).then {
            $0.size(CGSize.barButton)
            $0.imageEdgeInsets.left = 0
            $0.imageEdgeInsets.right = CGSize.barButton.width - image.size.width
            $0.setImage(image, for: UIControl.State.normal)
            $0.tintColor = .white
            $0.addTarget(for: .touchUpInside) { action() }
        }
        return UIBarButtonItem(customView: button)
    }
    
    static func menu(action: @escaping () -> Void) -> UIBarButtonItem {
        return rightButton(image: #imageLiteral(resourceName: "menu20"), action: action)
    }
    
    static func rightButton(image: UIImage, action: @escaping () -> Void) -> UIBarButtonItem {
        let button = UIButton(type: .system).then {
            let buttonImage = image.withRenderingMode(.alwaysTemplate)
            $0.size(CGSize.barButton)
            $0.imageEdgeInsets.left = CGSize.barButton.width - image.size.width
            $0.imageEdgeInsets.right = 0
            $0.setImage(buttonImage, for: .normal)
            $0.tintColor = .white
            $0.addTarget(for: .touchUpInside) { action() }
        }
        return UIBarButtonItem(customView: button)
    }
    
    static func titledButton(title: String, color: UIColor = .white, action: @escaping () -> Void) -> UIBarButtonItem {
        let button = UIButton(type: .system).then {
            $0.titleLabel?.font = .circular(style: .medium, size: 17.0)
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(color, for: .normal)
            $0.addTarget(for: .touchUpInside) { action() }
        }
        
        return UIBarButtonItem(customView: button)
    }
}
