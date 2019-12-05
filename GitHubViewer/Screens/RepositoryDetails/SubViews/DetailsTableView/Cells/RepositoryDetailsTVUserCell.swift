import UIKit

final class RepositoryDetailsTVUserCell: UITableViewCell {
    
    var cellTapped: (User) -> Void = { _ in }
    
    private let avatarView = ImageContentView()
    private let nameLabel = UILabel()
    private let loginLabel = UILabel()
    private let arrowView = UIImageView()
    private let avatarPlaceHolder = #imageLiteral(resourceName: "AvatarPlaceholder")
    
    private var user: User?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    //MARK: - Actions
    private func setup() {
        avatarView.add(to: contentView).do {
            $0.leftToSuperview(offset: Theme.avatarLeftOffset)
            $0.centerYToSuperview()
            $0.size(Theme.avatarSize)
        }
        nameLabel.add(to: contentView).do {
            $0.leftToRight(of: avatarView, offset: Theme.nameLeftOffset)
            $0.rightToSuperview()
            $0.centerYToSuperview(offset: -Theme.nameVerticalOffset)
            $0.height(Theme.nameHeight)
            
            $0.font = Theme.nameFont
            $0.textColor = .darkCoal
        }
        loginLabel.add(to: contentView).do {
            $0.left(to: nameLabel)
            $0.rightToSuperview()
            $0.centerYToSuperview(offset: Theme.loginVerticalOffset)
            $0.height()
            
            $0.font = Theme.loginFont
            $0.textColor = .textGray
        }
        arrowView.add(to: contentView).do {
            $0.rightToSuperview(offset: -Theme.arrowRightOffset)
            $0.centerYToSuperview()
            $0.size(Theme.arrowSize)
            
            $0.contentMode = .scaleAspectFit
            $0.image = #imageLiteral(resourceName: "chevronRight20")
        }
    }
    
    func configure(user: User) {
        self.user = user
        nameLabel.text = user.name
        loginLabel.text = user.login
        if let avatarUrl = URL(string: user.avatarURL) {
            avatarView.configure(url: avatarUrl, diameter: Theme.avatarSize.width, animated: true)
        } else {
            avatarView.configure(image: avatarPlaceHolder, animated: true)
        }
    }
    
    override func prepareForReuse() {
        user = nil
        nameLabel.text = nil
        loginLabel.text = nil
        avatarView.configure(image: avatarPlaceHolder, animated: false)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        guard let selectedUser = user, selected else { return }
        cellTapped(selectedUser)
    }
}

//MARK: - Theme
extension RepositoryDetailsTVUserCell {
    enum Theme {
        // Fonts
        static let nameFont: UIFont = .circular(style: .bold, size: 14.0)
        static let loginFont: UIFont = .cf(style: .compactDisplayThin, size: 13.0)
        
        // Sizes
        static let avatarSize: CGSize = CGSize(30.0)
        static let nameHeight: CGFloat = 15.0
        static let loginHeight: CGFloat = 15.0
        static let arrowSize: CGSize = CGSize(20.0)
        
        // Offsets
        static let avatarLeftOffset: CGFloat = 10.0
        static let nameLeftOffset: CGFloat = 15.0
        static let nameVerticalOffset: CGFloat = 10.0
        static let loginVerticalOffset: CGFloat = 10.0
        static let arrowRightOffset: CGFloat = 5.0
    }
}
