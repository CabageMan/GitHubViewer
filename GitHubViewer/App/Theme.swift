import UIKit

//MARK: - Colors
extension UIColor {
    // Views
    static let darkCoal         = #colorLiteral(red: 0.1647058824, green: 0.1921568627, blue: 0.2156862745, alpha: 1) // #2A3137
    static let barBlack         = #colorLiteral(red: 0.1411764706, green: 0.1607843137, blue: 0.1803921569, alpha: 1) // #24292E
    static let lightCoal        = #colorLiteral(red: 0.2470588235, green: 0.2666666667, blue: 0.2823529412, alpha: 1) // #3F4448
    static let mainBackground   = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1) // #F9F9F9
    
    // Fields
    static let fieldBackground      = #colorLiteral(red: 0.9098039216, green: 0.9411764706, blue: 0.9960784314, alpha: 1) // #E8F0FE
    static let selectedFieldBorder  = #colorLiteral(red: 0.1294117647, green: 0.5333333333, blue: 1, alpha: 1) // #2188FF
    static let selectedFieldShadow  = #colorLiteral(red: 0.7333333333, green: 0.8196078431, blue: 0.9568627451, alpha: 1) // #BBD1F4
    static let fieldBorderColor     = #colorLiteral(red: 0.8470588235, green: 0.8705882353, blue: 0.8862745098, alpha: 1) // #D8DEE2
    
    // Buttons
    static let buttonGreen  = #colorLiteral(red: 0.1529411765, green: 0.6549019608, blue: 0.2666666667, alpha: 1) // #27A744
    static let buttonBorder = #colorLiteral(red: 0.1647058824, green: 0.4588235294, blue: 0.2352941176, alpha: 1) // #2A753C
    
    // Texts
    static let textGray     = #colorLiteral(red: 0.6666666667, green: 0.6784313725, blue: 0.6862745098, alpha: 1) // #AAADAF
    static let selectedText = #colorLiteral(red: 0.7843137255, green: 0.7882352941, blue: 0.7960784314, alpha: 1) // #C8C9CB
    static let textDarkBlue = #colorLiteral(red: 0.007843137255, green: 0.4, blue: 0.8392156863, alpha: 1) // #0266D6
}

//MARK: - Sizes
extension CGFloat {
    // Common
    static let defaultCornerRadius: CGFloat = 5.0
    
    // Buttons
    static let defaultButtonHeight: CGFloat = 50.0
    
    // Safe Area
    static let defaultPadding: CGFloat = 5.0
    static var safeLeft: CGFloat {
        return AppDelegate.shared.window?.safeAreaInsets.left ?? defaultPadding
    }
    
    static var safeRight: CGFloat {
        return AppDelegate.shared.window?.safeAreaInsets.right ?? defaultPadding
    }
    
    static var safeTop: CGFloat {
        return AppDelegate.shared.window?.safeAreaInsets.top ?? defaultPadding
    }
    
    static var safeBottom: CGFloat {
        return AppDelegate.shared.window?.safeAreaInsets.bottom ?? defaultPadding
    }
    
    static var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
}
