import UIKit

final class IssueCommentCell: UICollectionViewCell {
    
    private let authorAvatar = ImageContentView()
    private let commentContainer = UIView()
    private let descriptionContainer = UIView()
    private let descriptionLabel = UILabel()
    private let contentTextView = UITextView()
    
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
        }
        
        commentContainer.add(to: contentView).do {
            $0.leftToRight(of: authorAvatar, offset: Theme.containerSideOffset)
            $0.rightToSuperview(offset: -Theme.containerSideOffset)
            $0.topToSuperview()
            $0.height(Theme.containerHeight)
            $0.layer.borderColor = Theme.containerBorderColor.cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.cornerRadius = 3.0
            $0.layer.addSublayer(createTriangle())
        }
        
        descriptionContainer.add(to: commentContainer).do {
            $0.edgesToSuperview(excluding: .bottom)
            $0.height(Theme.descriptionHeight)
            $0.backgroundColor = Theme.descriptionColor
        }
        
        descriptionLabel.add(to: descriptionContainer).do {
            $0.edgesToSuperview(excluding: .left)
            $0.leftToSuperview(offset: Theme.descriptionLeftOffset)
            $0.textAlignment = .left
            $0.font = Theme.descriptionLabelFont
        }
        
        UIView().add(to: descriptionContainer).do {
            $0.edgesToSuperview(excluding: .top)
            $0.height(1.0)
            $0.backgroundColor = Theme.containerBorderColor
        }
        
        contentTextView.add(to: commentContainer).do {
            $0.topToBottom(of: descriptionLabel, offset: Theme.commentContentOffset)
            $0.leftToSuperview(offset: Theme.commentContentOffset)
            $0.rightToSuperview(offset: -Theme.commentContentOffset)
            $0.bottomToSuperview(offset: -Theme.commentContentOffset)
            
//            $0.translatesAutoresizingMaskIntoConstraints = true
//            $0.sizeToFit()
            $0.isEditable = false 
            $0.isScrollEnabled = false
            $0.backgroundColor = .clear
            $0.textAlignment = .left
            $0.textColor = .darkCoal
            $0.font = Theme.descriptionLabelFont
        }
    }
    
    private func createTriangle() -> CAShapeLayer {
        // Temporary solution
        let path = UIBezierPath().then {
            $0.move(to: CGPoint(x: 0.0, y: 11.0))
            $0.addLine(to: CGPoint(x: -8.0, y: 15.0))
            $0.addLine(to: CGPoint(x: 0.0, y: 19.0))
        }
        
        return CAShapeLayer().then {
            $0.path = path.cgPath
            $0.fillColor = Theme.containerBorderColor.cgColor
            $0.lineWidth = 1.0
            $0.strokeColor = Theme.containerBorderColor.cgColor
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        authorAvatar.configure(image: Theme.avatarPlaceHolder, animated: false)
        descriptionLabel.attributedText = nil
        contentTextView.text = nil
    }
}

//MARK: - Configure Cell
extension IssueCommentCell: ConfigurableCell {
    typealias CellData = IssueComment
    
    func configure(with data: IssueComment) {
        let comment = data
        
        if let avatarURL = URL(string: comment.authorAvatarURL) {
            authorAvatar.configure(url: avatarURL, diameter: Theme.avatarSize.width, animated: true)
        } else {
            authorAvatar.configure(image: Theme.avatarPlaceHolder, animated: true)
        }
        
        descriptionLabel.attributedText = makeCommentDescription(for: comment)
        contentTextView.text = comment.bodyText
    }
    
    private func makeCommentDescription(for comment: IssueComment) -> NSAttributedString {
        let authorLogin = (comment.authorLogin + " ").attributed.paint(with: .darkCoal)
        let details = (String.Issues.commented + " " + "\(comment.createdAt.timeAgo)" + " " + String.General.ago).attributed.paint(with: .textGray)
        return authorLogin + details
    }
}

//MARK: - Theme
extension IssueCommentCell {
    enum Theme {
        // Images
        static let avatarPlaceHolder = #imageLiteral(resourceName: "AvatarPlaceholder")
        
        // Colors
        static let descriptionColor: UIColor = #colorLiteral(red: 0.9411764706, green: 0.9725490196, blue: 1, alpha: 1) // #F0F8FF
        static let containerBorderColor: UIColor = #colorLiteral(red: 0.8509803922, green: 0.8980392157, blue: 0.9607843137, alpha: 1) // #D9E5F5
        
        // Fonts
        static let descriptionLabelFont: UIFont = .circular(style: .medium, size: 13.0)
        
        // Sizes
        static let avatarSize = CGSize(30.0)
        static let descriptionHeight: CGFloat = 30.0
        static var containerWidth: CGFloat {
            return UIScreen.main.bounds.width - avatarLeftOffset - avatarSize.width - 2 * containerSideOffset
        }
        static let containerHeight: CGFloat = 80.0
        
        // Offsets
        static let avatarLeftOffset: CGFloat = 5.0
        static let containerSideOffset: CGFloat = 10.0
        static let descriptionLeftOffset: CGFloat = 8.0
        static let commentContentOffset: CGFloat = 5.0
    }
}
