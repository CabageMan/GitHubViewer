import UIKit

final class SelectorView: UIView {
    
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    
    init(icon: UIImage, title: String) {
        super.init(frame: .zero)
        isUserInteractionEnabled = true
        iconView.add(to: self).do {
            $0.leftToSuperview()
            $0.centerYToSuperview()
            $0.size(Theme.iconSize)
            $0.contentMode = .scaleAspectFit
            $0.image = icon.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .darkCoal
        }
        
        titleLabel.add(to: self).do {
            $0.leftToRight(of: iconView, offset: Theme.titleLeftOffset)
            $0.centerYToSuperview()
            $0.size(CGSize(width: Theme.titleWidth, height: Theme.titleHeight))
            $0.textAlignment = .left
            $0.font = Theme.titleFont
            $0.textColor = .darkCoal
            $0.text = title
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    //MARK: - Actions
    func setSelected(isSelected: Bool) {
        iconView.tintColor = isSelected ? .darkCoal : .textGray
        titleLabel.textColor = isSelected ? .darkCoal : .textGray
    }
}

//MARK: - Theme
extension SelectorView {
    enum Theme {
        // Fonts
        static let titleFont: UIFont = .circular(style: .medium, size: 13.0)
        
        // Sizes
        static let iconSize = CGSize(17.0)
        static let titleWidth: CGFloat = 45.0
        static let titleHeight: CGFloat = 17.0
        
        // Offsets
        static let iconTopOffset: CGFloat = 8.0
        static let titleLeftOffset: CGFloat = 8.0
    }
}
