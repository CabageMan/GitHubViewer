import UIKit

final class RepositoryCollectionCell: UICollectionViewCell {
    
    private let container = UIView()
    private let statusImageView = UIImageView()
    private let colorView = UIView()
    private let languageLabel = UILabel()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let arrowView = UIImageView()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        contentView.backgroundColor = .clear
        
        dropShadow()
        
        container.add(to: contentView).do {
            $0.edgesToSuperview()
            
            $0.backgroundColor = .white
            $0.layer.cornerRadius = .defaultCornerRadius
            $0.clipsToBounds = true
        }
        
        statusImageView.add(to: container).do {
            $0.leftToSuperview(offset: Theme.statusLeftOffset)
            $0.topToSuperview(offset: Theme.statusTopOffset)
            $0.size(Theme.statusImageSize)
            
            $0.contentMode = .scaleAspectFit
        }
        
        nameLabel.add(to: container).do {
            $0.leftToRight(of: statusImageView, offset: Theme.nameLeftOffset)
            $0.rightToSuperview()
            $0.top(to: statusImageView)
            $0.height(Theme.nameLabelHeight)
            
            $0.textAlignment = .left
            $0.font = Theme.nameLabelFont
            $0.textColor = .darkCoal
        }
        
        descriptionLabel.add(to: container).do {
            $0.left(to: nameLabel)
            $0.topToBottom(of: nameLabel, offset: Theme.descriptionTopOffset)
            $0.height(Theme.descriptionLabelHeight)
            
            $0.textAlignment = .left
            $0.font = Theme.descriptionLabelFont
            $0.textColor = .lightCoal
        }
        
        colorView.add(to: container).do {
            $0.left(to: statusImageView, offset: Theme.colorViewLeftOffset)
            $0.topToBottom(of: descriptionLabel, offset: Theme.colorViewTopOffset)
            $0.size(Theme.colorViewSize)
            
            $0.setRoundedMask(radius: Theme.colorViewSize.width / 2)
            $0.backgroundColor = .clear
        }
        
        languageLabel.add(to: container).do {
            $0.leftToRight(of: colorView, offset: Theme.languageLabelLeftOffset)
            $0.bottom(to: colorView)
            $0.height(Theme.languageLabelHeight)
            
            $0.textAlignment = .left
            $0.font = Theme.languageLabelFont
            $0.textColor = .textGray
        }
        
        arrowView.add(to: container).do {
            $0.rightToSuperview(offset: -Theme.arrowRightOffset)
            $0.centerYToSuperview()
            $0.size(Theme.arrowSize)
            
            $0.image = #imageLiteral(resourceName: "chevronRight20")
            $0.contentMode = .scaleAspectFit
        }
    }
    
    //MARK: - Actions
    func configure(with repository: Repository) {
        if repository.isFork {
            statusImageView.image = #imageLiteral(resourceName: "fork")
        } else if repository.isPrivate {
            statusImageView.image = #imageLiteral(resourceName: "lock")
        } else {
            statusImageView.image = #imageLiteral(resourceName: "repository")
        }
        
        nameLabel.text = repository.name
        descriptionLabel.text = repository.description
        if let color = repository.primaryLanguage?.color {
            colorView.backgroundColor = UIColor(hexString: color)
        } else {
            colorView.backgroundColor = .clear
        }
        languageLabel.text = repository.primaryLanguage?.name
    }
}

//MARK: - Theme
extension RepositoryCollectionCell {
    enum Theme {
        // Fonts
        static let nameLabelFont: UIFont = .circular(style: .book, size: 16.0)
        static let descriptionLabelFont: UIFont = .circular(style: .medium, size: 13.0)
        static let languageLabelFont: UIFont = .circular(style: .medium, size: 10.0)
        
        // Sizes
        static let containerHeight: CGFloat = 97.0
        static let statusImageSize: CGSize = CGSize(30.0)
        static let colorViewSize: CGSize = CGSize(15.0)
        static let languageLabelHeight: CGFloat = 15.0
        static let nameLabelHeight: CGFloat = 20.0
        static let descriptionLabelHeight: CGFloat = 20.0
        static let arrowSize: CGSize = CGSize(20.0)
        
        // Offsets
        static let statusLeftOffset: CGFloat = 10.0
        static let statusTopOffset: CGFloat = 5.0
        static let colorViewTopOffset: CGFloat = 5.0
        static let colorViewLeftOffset: CGFloat = 4.0
        static let languageLabelLeftOffset: CGFloat = 5.0
        static let nameLeftOffset: CGFloat = 10.0
        static let descriptionTopOffset: CGFloat = 5.0
        static let arrowRightOffset: CGFloat = 5.0
    }
}
