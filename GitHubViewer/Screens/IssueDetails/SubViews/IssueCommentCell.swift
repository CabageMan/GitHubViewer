import UIKit

final class IssueCommentCell: UICollectionViewCell {
    
    private let authorAvatar = ImageContentView()
    private let commentContainer = UIView()
    private let descriptionContainer = UIView()
    
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
        
        UIView().add(to: descriptionContainer).do {
            $0.edgesToSuperview(excluding: .top)
            $0.height(1.0)
            $0.backgroundColor = Theme.containerBorderColor
        }
    }
    
    private func createTriangle() -> CAShapeLayer {
        // Temporary solution
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.0, y: 11.0))
        path.addLine(to: CGPoint(x: -8.0, y: 15.0))
        path.addLine(to: CGPoint(x: 0.0, y: 19.0))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = Theme.descriptionColor.cgColor
        shapeLayer.lineWidth = 1.0
        shapeLayer.strokeColor = Theme.containerBorderColor.cgColor
        
        return shapeLayer
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
        static let containerBorderColor: UIColor = #colorLiteral(red: 0.8509803922, green: 0.8980392157, blue: 0.9607843137, alpha: 1) // #D9E5F5
        
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
        static let containerSideOffset: CGFloat = 10.0
    }
}
