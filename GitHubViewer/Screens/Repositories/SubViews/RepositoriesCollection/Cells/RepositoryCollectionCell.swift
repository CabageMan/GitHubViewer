import UIKit

final class RepositoryCollectionCell: UICollectionViewCell {
    private let statusImageView = UIImageView()
    private let nameLabel = UILabel()
    private let createdAtLabel = UILabel()
    
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
        
        statusImageView.add(to: contentView).do {
            $0.leftToSuperview(offset: Theme.imageLeftOffset)
            $0.centerYToSuperview()
            $0.size(Theme.imageSize)
            
            $0.contentMode = .scaleAspectFit
        }
        
        nameLabel.add(to: contentView).do {
            $0.leftToRight(of: statusImageView, offset: Theme.nameLabelLeftOffset)
            $0.rightToSuperview()
            $0.topToSuperview(offset: Theme.nameLabelTopOffset)
            $0.height(Theme.nameLabelHeight)
            
            $0.textAlignment = .left
            $0.font = Theme.nameLabelFont
            $0.textColor = .darkCoal
        }
        
        createdAtLabel.add(to: contentView).do {
            $0.leftToRight(of: statusImageView, offset: Theme.nameLabelLeftOffset)
            $0.topToBottom(of: nameLabel, offset: Theme.createdAtTopOffset)
            $0.height(Theme.createdAtLabelHeight)
            
            $0.textAlignment = .left
            $0.font = Theme.createdAtLabelFont
            $0.textColor = .lightCoal
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
        createdAtLabel.text = repository.createdAt
    }
}

//MARK: - Theme
extension RepositoryCollectionCell {
    enum Theme {
        // Fonts
        static let nameLabelFont: UIFont = .circular(style: .book, size: 15.0)
        static let createdAtLabelFont: UIFont = .circular(style: .medium, size: 13.0)
        
        // Sizes
        static let imageSize: CGSize = CGSize(30.0)
        static let nameLabelHeight: CGFloat = 20.0
        static let createdAtLabelHeight: CGFloat = 20.0
        
        // Offsets
        static let imageLeftOffset: CGFloat = 10.0
        static let nameLabelLeftOffset: CGFloat = 10.0
        static let nameLabelTopOffset: CGFloat = 5.0
        static let createdAtTopOffset: CGFloat = 5.0
    }
}
