import UIKit

extension UIFont {
    //MARK: - CircularStd
    enum CircularStd: String {
        case black = "CircularStd-Black"
        case bold = "CircularStd-Bold"
        case book = "CircularStd-Book"
        case medium = "CircularStd-Medium"
    }
    
    static func circular(style: CircularStd, size: CGFloat) -> UIFont {
        return getFont(name: style.rawValue, size: size)
    }
    
    //MARK: - Actions
    private static func getFont(name: String, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: name, size: size) else {
            fatalError("Font with name: \(name) not founded!")
        }
        return font
    }
}
