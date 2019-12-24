import UIKit

final class PullRequestsCollectionCell: UICollectionViewCell {
    
    private let container = UIView()
    private let stateView = UIImageView()
    private let nameLabel = UILabel()
    private let detailsLabel = UILabel()
    private let labelMarker = UILabel()
    
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
            $0.edgesToSuperview()
            $0.backgroundColor = .white
        }
        
        UIView().add(to: container).do {
            $0.edgesToSuperview(excluding: .bottom)
            $0.height(1.0)
            $0.backgroundColor = .mainBackground
        }
        
        stateView.add(to: container).do {
            $0.leftToSuperview(offset: Theme.stateLeftOffset)
            $0.topToSuperview(offset: Theme.stateTopOffset)
            $0.size(Theme.stateImageSize)
            
            $0.contentMode = .scaleAspectFit
        }
        
        nameLabel.add(to: container).do {
            $0.leftToRight(of: stateView, offset: Theme.nameLabelOffset)
            $0.rightToSuperview()
            $0.top(to: stateView)
            $0.height(Theme.nameLabelHeight)
            
            $0.textAlignment = .left
            $0.font = Theme.nameLabelFont
            $0.textColor = .darkCoal
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

//MARK: - Configure Cell
extension PullRequestsCollectionCell: ConfigurableCell {
    typealias CellData = PullRequest
    
    func configure(with data: PullRequest) {
        let pullRequest = data
        nameLabel.text = pullRequest.headRefName
        let icon = #imageLiteral(resourceName: "pullRequest")
        stateView.image = icon.withRenderingMode(.alwaysTemplate)
        stateView.tintColor = Theme.openedColor
    }
}

//MARK: - Theme
extension PullRequestsCollectionCell {
    enum Theme {
        // Colors
        static let mergedColor: UIColor = #colorLiteral(red: 0.4352941176, green: 0.2588235294, blue: 0.7568627451, alpha: 1) // #6F42C1
        static let closedColor: UIColor = #colorLiteral(red: 0.7960784314, green: 0.137254902, blue: 0.1921568627, alpha: 1) // #CB2331
        static let openedColor: UIColor = #colorLiteral(red: 0.1529411765, green: 0.6549019608, blue: 0.2666666667, alpha: 1) // #27A744
        
        // Fonts
        static let nameLabelFont: UIFont = .circular(style: .book, size: 16.0)
        static let deailsLabelFont: UIFont = .circular(style: .medium, size: 13.0)
        static let labelMarkerFont: UIFont = .circular(style: .medium, size: 10.0)
        
        // Sizes
        static let stateImageSize = CGSize(25.0)
        static let nameLabelHeight: CGFloat = 20.0
        
       // Offsets
        static let stateLeftOffset: CGFloat = 16.0
        static let stateTopOffset: CGFloat = 10.0
        static let nameLabelOffset: CGFloat = 10.0
    }
}
