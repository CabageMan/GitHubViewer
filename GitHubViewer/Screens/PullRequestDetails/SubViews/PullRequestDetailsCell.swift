import UIKit

final class PullRequestDetailsCollectionCell: UICollectionViewCell {
    
    private let iconView = UIImageView()
    private let messageLabel = UILabel()
    
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
        
        iconView.add(to: contentView).do {
            $0.leftToSuperview(offset: Theme.iconLeftOffset)
            $0.centerYToSuperview()
            $0.size(Theme.iconSize)
            
            $0.contentMode = .scaleAspectFit
            $0.image = Theme.commitIcon
        }
        
        messageLabel.add(to: contentView).do {
            $0.leftToRight(of: iconView, offset: Theme.messageLeftOffset)
            $0.rightToSuperview()
            $0.centerYToSuperview()
            $0.height(Theme.messageHeight)
            
            $0.textAlignment = .left
            $0.font = Theme.messageFont
            $0.textColor = .lightCoal
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        messageLabel.text = nil
    }
}

//MARK: - Configure Cell
extension PullRequestDetailsCollectionCell: ConfigurableCell {
    typealias CellData = Commit
    
    func configure(with data: Commit) {
        let commit = data
        
        messageLabel.text = commit.message
    }
}

//MARK: - Theme
extension PullRequestDetailsCollectionCell {
    enum Theme {
        // Icons
        static let commitIcon: UIImage = #imageLiteral(resourceName: "commit25")
        
        // Fonts
        static let messageFont: UIFont = .circular(style: .medium, size: 13.0)
        
        // Sizes
        static let iconSize = CGSize(17.0)
        static let messageHeight: CGFloat = 19.0
        
        // Offsets
        static let iconLeftOffset: CGFloat = 23.0
        static let messageLeftOffset: CGFloat = 5.0
    }
}
