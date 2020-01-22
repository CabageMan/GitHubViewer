import UIKit

struct Buttons {
    private static var defaultButton: UIButton {
        return UIButton(type: .system).then {
            $0.contentEdgeInsets = Theme.buttonInsets
            $0.layer.cornerRadius = .defaultCornerRadius
            $0.layer.borderWidth = Theme.borderWidth
            $0.titleLabel?.font = Theme.buttonFont
        }
    }
    
    static func roundedButton(title: String) -> UIButton {
        return defaultButton.then {
            $0.backgroundColor = .buttonGreen
//            $0.setBackgroundColor(.buttonGreen, for: .normal)
//            $0.setBackgroundColor(Theme.disableGreen, for: .disabled)
            $0.layer.borderColor = UIColor.buttonGreenBorder.cgColor
            $0.tintColor = .white
            $0.setTitle(title, for: .normal)
        }
    }
    
    static func iconButton(icon: UIImage, title: String) -> UIButton {
        return defaultButton.then {
            $0.backgroundColor = .buttonLight
            $0.layer.borderColor = UIColor.buttonLightBorder.cgColor
            $0.tintColor = .darkCoal
            $0.setImage(icon, for: .normal)
            $0.setTitle(title, for: .normal)
            $0.imageEdgeInsets = Theme.buttonImageInsets
        }
    }
    
    //MARK: - Theme
    enum Theme {
        // Colors
        static let disableGreen = #colorLiteral(red: 0.1529411765, green: 0.6549019608, blue: 0.2666666667, alpha: 0.6952054795) // #27A744, opacity: 70%
        
        // Fonts
        static let buttonFont: UIFont = .circular(style: .book, size: 18)
        
        // Isets
        static let buttonInsets = UIEdgeInsets(top: 0, left: 20.0, bottom: 0, right: 20.0)
        static let buttonImageInsets = UIEdgeInsets(top: 0, left: -8.0, bottom: 0, right: 8.0)
        
        // Sizes
        static let borderWidth: CGFloat = 1.0
    }
}
