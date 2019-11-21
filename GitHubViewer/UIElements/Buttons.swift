import UIKit

struct Buttons {
    static var roundedButton: UIButton {
        return UIButton(type: .system).then {
            $0.height(.defaultButtonHeight)
            $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20.0, bottom: 0, right: 20.0)
            $0.layer.cornerRadius = .defaultCornerRadius
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = UIColor.buttonBorder.cgColor
            $0.titleLabel?.font = .circular(style: .book, size: 18)
            $0.tintColor = .white
            $0.backgroundColor = .buttonGreen
        }
    }
}
