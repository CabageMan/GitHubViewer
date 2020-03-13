import UIKit

final class ProfilePinnedCell: UICollectionViewCell {
    
    private let container = UIView()
    private let typeView = UIImageView()
    private let nameLabel = UILabel()
    private let colorView = UIView()
    private let languageLabel = UILabel()
    private let starView = UIImageView()
    private let starCountLabel = UILabel()
    private let forkView = UIImageView()
    private let forkCountLabel = UILabel()
    
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
        container.add(to: contentView).do {
            $0.edgesToSuperview(excluding: [.top, .bottom])
            $0.topToSuperview(offset: Theme.containerVerticalOffset)
            $0.bottomToSuperview(offset: -Theme.containerVerticalOffset)
            $0.backgroundColor = .white
            $0.layer.borderWidth = Theme.containerBorderWith
            $0.layer.cornerRadius = Theme.containerCornerRadius
            $0.layer.borderColor = Theme.containerBorderColor
        }
        
        typeView.add(to: container).do {
            $0.leftToSuperview(offset: Theme.typeViewLeftOffset)
            $0.topToSuperview(offset: Theme.typeViewTopOffset)
            $0.size(Theme.typeViewSize)
            $0.contentMode = .scaleAspectFit
        }
        
        nameLabel.add(to: container).do {
            $0.leftToRight(of: typeView, offset: Theme.nameLeftOffset)
            $0.rightToSuperview()
            $0.top(to: typeView)
            $0.height(Theme.nameHeight)
            $0.textAlignment = .left
            $0.font = Theme.nameFont
            $0.textColor = .darkCoal
        }
        
        colorView.add(to: container).do {
            $0.left(to: typeView)
            $0.bottomToSuperview(offset: -Theme.colorViewBottomOffset)
            $0.size(CGSize(Theme.colorViewRadius * 2))
            $0.setRoundedMask(radius: Theme.colorViewRadius)
            $0.backgroundColor = .clear
        }
        
        languageLabel.add(to: container).do {
            $0.leftToRight(of: colorView, offset: Theme.languageLeftOffset)
            $0.bottom(to: colorView)
            $0.height(Theme.languageHeight)
            $0.textAlignment = .left
            $0.font = Theme.languageFont
            $0.textColor = .textGray
        }
        
        starView.add(to: container).do {
            $0.leftToRight(of: languageLabel, offset: Theme.starViewLeftOffset)
            $0.bottom(to: colorView)
            $0.size(Theme.starViewSize)
            $0.contentMode = .scaleAspectFit
            $0.image = #imageLiteral(resourceName: "star")
        }
        
        starCountLabel.add(to: container).do {
            $0.leftToRight(of: starView, offset: Theme.starCountLeftOffset)
            $0.bottom(to: colorView)
            $0.height(Theme.starCountHeight)
            $0.textAlignment = .left
            $0.font = Theme.languageFont
            $0.textColor = .textGray
        }
        
        forkView.add(to: container).do {
            $0.leftToRight(of: starCountLabel, offset: Theme.forkViewLeftOffset)
            $0.bottom(to: colorView)
            $0.size(Theme.starViewSize)
            $0.contentMode = .scaleAspectFit
            $0.image = #imageLiteral(resourceName: "littleFork")
        }
        
        forkCountLabel.add(to: container).do {
            $0.leftToRight(of: forkView, offset: Theme.forkCountLeftOffset)
            $0.bottom(to: colorView)
            $0.height(Theme.forkCountHeight)
            $0.textAlignment = .left
            $0.font = Theme.languageFont
            $0.textColor = .textGray
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        typeView.image = nil
        nameLabel.text = nil
        colorView.backgroundColor = .clear
        languageLabel.text = nil
        starCountLabel.text = nil
        forkCountLabel.text = nil
    }
}

//MARK: - Configure  Cell
extension ProfilePinnedCell: ConfigurableCell {
    typealias CellData = ProfilePinnedItem
    
    func configure(with data: ProfilePinnedItem) {
        switch data {
        case .repository(let repository):
            configureRepository(repository)
        case .gist(let gist):
            configureGist(gist)
        }
    }
    
    private func configureRepository(_ repository: Repository) {
        typeView.image = #imageLiteral(resourceName: "repository")
        nameLabel.text = repository.name
        if let color = repository.primaryLanguage?.color {
            colorView.backgroundColor = UIColor(hexString: color)
        } else {
            colorView.backgroundColor = .clear
        }
        languageLabel.do {
            $0.isHidden = false
            $0.text = repository.primaryLanguage?.name
        }
        starView.isHidden = false
        starCountLabel.do {
            $0.isHidden = false
            $0.text = "\(repository.stargazersCount)"
        }
        forkView.isHidden = false
        forkCountLabel.do {
            $0.isHidden = false
            $0.text = "\(repository.forkCount)"
        }
    }
    
    private func configureGist(_ gist: Gist) {
        guard let gistName = gist.description else { return }
        typeView.image = #imageLiteral(resourceName: "code")
        nameLabel.text = gistName
        colorView.isHidden = true
        languageLabel.isHidden = true
        starView.isHidden = true
        starCountLabel.isHidden = true
        forkView.isHidden = true
        forkCountLabel.isHidden = true
    }
}

//MARK: - Theme
extension ProfilePinnedCell {
    enum Theme {
        // Colors
        static let containerBorderColor = #colorLiteral(red: 0.8196078431, green: 0.8352941176, blue: 0.8549019608, alpha: 1).cgColor // #D1D5DA
        
        // Fonts
        static let nameFont: UIFont = .circular(style: .book, size: 16.0)
        static let languageFont: UIFont = .circular(style: .medium, size: 10.0)
        
        // Sizes
        static let containerCornerRadius: CGFloat = 3.0
        static let containerBorderWith: CGFloat = 1.0
        static let typeViewSize = CGSize(20.0)
        static let nameHeight: CGFloat = 20.0
        static let colorViewRadius: CGFloat = 7.5
        static let languageHeight: CGFloat = 15.0
        static let starViewSize = CGSize(15.0)
        static let starCountHeight: CGFloat = 15.0
        static let forkViewSize = CGSize(15.0)
        static let forkCountHeight: CGFloat = 15.0
        
        // Offsets
        static let containerVerticalOffset: CGFloat = 5.0
        static let typeViewLeftOffset: CGFloat = 10.0
        static let typeViewTopOffset: CGFloat = 5.0
        static let nameLeftOffset: CGFloat = 10.0
        static let colorViewBottomOffset: CGFloat = 5.0
        static let languageLeftOffset: CGFloat = 5.0
        static let starViewLeftOffset: CGFloat = 10.0
        static let starCountLeftOffset: CGFloat = 5.0
        static let forkViewLeftOffset: CGFloat = 10.0
        static let forkCountLeftOffset: CGFloat = 5.0
    }
}
