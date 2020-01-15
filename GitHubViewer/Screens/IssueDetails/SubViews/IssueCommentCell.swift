import UIKit

final class IssueCommentCell: UICollectionViewCell {
    
    private let authorAvatar = ImageContentView()
    private let commentContainer = UIView()
    
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
        contentView.backgroundColor = .clear
        
        authorAvatar.add(to: contentView).do {
            $0.leftToSuperview(offset: Theme.avatarLeftOffset)
            $0.topToSuperview()
            $0.size(Theme.avatarSize)
            #warning("Temporary avatar")
            authorAvatar.configure(image: Theme.avatarPlaceHolder, animated: true)
        }
        
        commentContainer.add(to: contentView).do {
            $0.leftToRight(of: authorAvatar, offset: Theme.containerSideOffset)
            $0.rightToSuperview(offset: Theme.containerSideOffset)
            $0.topToSuperview()
        }
    }
    
    private func drawContainer() {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        authorAvatar.configure(image: Theme.avatarPlaceHolder, animated: false)
    }
}

//MARK: - Configure Cell
extension IssueCommentCell: ConfigurableCell {
    typealias CellData = IssueComment
    
    func configure(with data: IssueComment) {
//        let comment = data
        
    }
}

//MARK: - Theme
extension IssueCommentCell {
    enum Theme {
        // Images
        static let avatarPlaceHolder = #imageLiteral(resourceName: "AvatarPlaceholder")
        
        // Colors
        static let descriptionColor: UIColor = #colorLiteral(red: 0.9411764706, green: 0.9725490196, blue: 1, alpha: 1) // #F0F8FF
        static let descriptionBorderColor: UIColor = #colorLiteral(red: 0.8509803922, green: 0.8980392157, blue: 0.9607843137, alpha: 1) // #D9E5F5
        
        // Fonts
        
        // Sizes
        static let avatarSize = CGSize(30.0)
        static let descriptionHeight: CGFloat = 30.0
        static var containerWidth: CGFloat {
            return UIScreen.main.bounds.width - avatarLeftOffset - avatarSize.width - 2 * containerSideOffset
        }
        static let containerHeight: CGFloat = 80.0
        
        // Offsets
        static let avatarLeftOffset: CGFloat = 5.0
        static let containerSideOffset: CGFloat = 8.0
    }
}
