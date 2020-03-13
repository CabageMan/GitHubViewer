import UIKit

final class ProfileTitleView: UIView {
    
    private let titleLabel = UILabel()
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        height(Theme.height)
        titleLabel.add(to: self).do {
            $0.leftToSuperview(offset: Theme.titleOffset)
            $0.bottomToSuperview()
            $0.height(Theme.titleHeight)
            $0.textAlignment = .left
            $0.font = Theme.titleFont
        }
    }
    
    //MARK: - Actions
    func update(title: String) {
        titleLabel.text = title
    }
}

//MARK: - Theme
extension ProfileTitleView {
    enum Theme {
        // Fonts
        static let titleFont: UIFont = .circular(style: .book, size: 16.0)
        // Sizes
        static let height: CGFloat = 50.0
        static let titleHeight: CGFloat = 20.0
        // Offsets
        static let titleOffset: CGFloat = 20.0
    }
}
