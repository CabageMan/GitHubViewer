import UIKit

final class UserCard: UIView {
    
    private let avatarView = ImageContentView()
    private let nameLabel = UILabel()
    private let loginLabel = UILabel()
    private let envelopeImageView = UIImageView()
    private let emailLabel = UILabel()
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    //MARK: - Actions
    private func setup() {
        avatarView.add(to: self).do {
            $0.topToSuperview()
            $0.leftToSuperview()
            $0.widthToSuperview()
            $0.heightToSuperview(offset: -Theme.avatarHeightOffset)
        }
        
        nameLabel.add(to: self).do {
            $0.topToBottom(of: avatarView, offset: Theme.nameLabelTopOffset)
            $0.leftToSuperview()
            $0.height(Theme.nameLabelHeight)
            
            $0.textAlignment = .left
            $0.textColor = .darkCoal
            $0.font = Theme.nameLabelFont
        }
        
        loginLabel.add(to: self).do {
            $0.topToBottom(of: nameLabel, offset: Theme.loginLabelTopOffset)
            $0.leftToSuperview()
            $0.height(Theme.loginLabelHeight)
            
            $0.textAlignment = .left
            $0.textColor = .lightCoal
            $0.font = Theme.loginLabelFont
        }
        
        envelopeImageView.add(to: self).do {
            $0.topToBottom(of: loginLabel, offset: Theme.emailLabelTopOffset)
            $0.leftToSuperview()
            $0.size(Theme.envelopeSize)
            
            $0.contentMode = .scaleAspectFit
            $0.image = #imageLiteral(resourceName: "envelope")
        }
        
        emailLabel.add(to: self).do {
            $0.top(to: envelopeImageView)
            $0.leftToRight(of: envelopeImageView, offset: Theme.emailLabelLeftOffset)
            $0.height(Theme.emailLabelHeight)
            
            $0.textAlignment = .left
            $0.textColor = .lightGray
            $0.font = Theme.emailLabelFont
        }
    }
    
    func configure(with user: User) {
        if let avatarUrl = URL(string: user.avatarURL) {
            avatarView.configure(url: avatarUrl, diameter: Theme.avatarDiameter, animated: true)
        } else {
            avatarView.configure(image: Theme.avatarPlaceHolder, animated: true)
        }
        nameLabel.text = user.name
        loginLabel.text = user.login
        emailLabel.text = user.email
    }
}

//MARK: - Theme
extension UserCard {
    enum Theme {
        // Images
        static let avatarPlaceHolder = #imageLiteral(resourceName: "AvatarPlaceholder")
        
        // Fonts
        static let nameLabelFont: UIFont = .circular(style: .bold, size: 23.0)
        static let loginLabelFont: UIFont = .circular(style: .medium, size: 16.0)
        static let emailLabelFont: UIFont = .circular(style: .medium, size: 13.0)
        
        // Sizes
        static var avatarDiameter: CGFloat {
            return UIScreen.main.bounds.width - ProfileCollectionCell.Theme.contentSideOffset * 2
        }
        static let nameLabelHeight: CGFloat = 25.0
        static let loginLabelHeight: CGFloat = 17.0
        static let envelopeSize = CGSize(15.0)
        static let emailLabelHeight: CGFloat = 15.0
        
        // Offsets
        static var avatarHeightOffset: CGFloat {
            return nameLabelHeight + nameLabelTopOffset + loginLabelHeight + loginLabelTopOffset + emailLabelHeight + emailLabelTopOffset
        }
        static let nameLabelTopOffset: CGFloat = 5.0
        static let loginLabelTopOffset: CGFloat = 5.0
        static let emailLabelTopOffset: CGFloat = 5.0
        static let emailLabelLeftOffset: CGFloat = 5.0
    }
}
