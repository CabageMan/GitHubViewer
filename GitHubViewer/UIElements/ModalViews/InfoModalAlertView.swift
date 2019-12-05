import UIKit

final class InfoModalAlertView: UIView, ModalAlertViewCompatibility {
    var closeAction: () -> Void = { }
    
    private let title: String
    private let details: String?
    
    init(title: String, details: String? = nil) {
        self.title = title
        self.details = details
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented") }
    
    private func setup() {
        let titleLabel = UILabel().add(to: self).then {
            $0.leftToSuperview(offset: Theme.titleLabelSideOffset)
            $0.rightToSuperview(offset: -Theme.titleLabelSideOffset)
            $0.topToSuperview(offset: Theme.titleLabelTopOffset)
            
            $0.font = Theme.titleLabelFont
            $0.numberOfLines = 0
            $0.textAlignment = .center
            $0.text = title
        }
        
        if let info = details {
            UILabel().add(to: self).do {
                $0.left(to: titleLabel)
                $0.right(to: titleLabel)
                $0.topToBottom(of: titleLabel, offset: Theme.detailsLabelTopOffset)
                
                $0.font = Theme.detailsLabelFont
                $0.numberOfLines = 0
                $0.textAlignment = .center
                $0.text = info
            }
        }
        
        Buttons.roundedButton.add(to: self).do {
            $0.leftToSuperview(offset: Theme.okButtonSideOffset)
            $0.rightToSuperview(offset: -Theme.okButtonSideOffset)
            $0.bottomToSuperview(offset: -Theme.okButtonBottomOffset)
            
            $0.setTitle(String.General.ok, for: .normal)
            $0.addTarget(for: .touchUpInside) { [unowned self] in self.closeAction() }
        }
    }
}

//MARK: - Theme
extension InfoModalAlertView {
    enum Theme {
        // Fonts
        static let titleLabelFont: UIFont = .circular(style: .bold, size: 34.0)
        static let detailsLabelFont: UIFont = .circular(style: .medium, size: 14.0)
        
        // Offsets
        static let titleLabelSideOffset: CGFloat = 15.0
        static let titleLabelTopOffset: CGFloat = 72.0
        static let detailsLabelTopOffset: CGFloat = 17.0
        static let okButtonSideOffset: CGFloat = 30.0
        static let okButtonBottomOffset: CGFloat = 13.0
    }
}
