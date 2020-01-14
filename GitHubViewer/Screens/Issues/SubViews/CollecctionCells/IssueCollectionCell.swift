import UIKit

final class IssueCollectionCell: UICollectionViewCell {
    
    private let container = UIView()
    private let stateView = UIImageView()
    private let resourcePathLabel = UILabel()
    private let titleLabel = UILabel()
    private let detailsLabel = UILabel()
    
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
            let issueIcon = #imageLiteral(resourceName: "openIssue")
            $0.image = issueIcon.withRenderingMode(.alwaysTemplate)
        }
        
        resourcePathLabel.add(to: container).do {
            $0.leftToRight(of: stateView, offset: Theme.titleLeftOffset)
            $0.rightToSuperview()
            $0.top(to: stateView)
            $0.height(Theme.titleHeight)
            
            $0.textAlignment = .left
            $0.font = Theme.titleLabelFont
            $0.textColor = .lightCoal
        }
        
        titleLabel.add(to: container).do {
            $0.left(to: resourcePathLabel)
            $0.rightToSuperview()
            $0.topToBottom(of: resourcePathLabel, offset: Theme.labelsTopOffset)
            $0.height(Theme.titleHeight)
            
            $0.textAlignment = .left
            $0.font = Theme.titleLabelFont
            $0.textColor = .darkCoal
        }
        
        detailsLabel.add(to: container).do {
            $0.left(to: resourcePathLabel)
            $0.rightToSuperview()
            $0.topToBottom(of: titleLabel, offset: Theme.labelsTopOffset)
            $0.height()
            
            $0.textAlignment = .left
            $0.font = Theme.deailsLabelFont
            $0.textColor = .textGray
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        resourcePathLabel.text = nil
        titleLabel.text = nil
        stateView.tintColor = .clear
    }
}

//MARK: - Configure Cell
extension IssueCollectionCell: ConfigurableCell {
    typealias CellData = Issue
    
    func configure(with data: Issue) {
        let issue = data
        
        stateView.tintColor = issue.state == .open ? Theme.openColor : Theme.closedColor
        resourcePathLabel.text = issue.repository.resourcePath
        titleLabel.text = issue.title
        detailsLabel.text = makeDetailsDescription(for: issue)
    }
    
    private func makeDetailsDescription(for issue: Issue) -> String {
        if case .open = issue.state {
            return String.Issues.openedBy("\(issue.number)", "\(issue.createdAt.timeAgo)", "\(issue.author)")
        } else {
            var closedTimeAgo = String()
            if let closedAt = issue.closedAt {
                closedTimeAgo = closedAt.timeAgo
            }
            return String.Issues.closedBy("\(issue.number)", "\(issue.author)", "\(closedTimeAgo)")
        }
    }
}

//MARK: - Theme
extension IssueCollectionCell {
    enum Theme {
        // Colors
        static let openColor: UIColor = #colorLiteral(red: 0.1529411765, green: 0.6549019608, blue: 0.2666666667, alpha: 1) // #27A744
        static let closedColor: UIColor = #colorLiteral(red: 0.7960784314, green: 0.137254902, blue: 0.1921568627, alpha: 1) // #CB2331
        
        // Fonts
        static let titleLabelFont: UIFont = .circular(style: .book, size: 16.0)
        static let deailsLabelFont: UIFont = .circular(style: .medium, size: 13.0)
        
        // Sizes
        static let stateImageSize = CGSize(17.0)
        static let titleHeight: CGFloat = 19.0
        
        // Offsets
        static let stateLeftOffset: CGFloat = 13.0
        static let stateTopOffset: CGFloat = 8.0
        static let labelsTopOffset: CGFloat = 5.0
        static let titleLeftOffset: CGFloat = 5.0
    }
}
