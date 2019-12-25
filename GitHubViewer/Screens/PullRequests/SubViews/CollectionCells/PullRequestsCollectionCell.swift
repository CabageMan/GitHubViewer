import UIKit

final class PullRequestsCollectionCell: UICollectionViewCell {
    
    private let container = UIView()
    private let stateView = UIImageView()
    private let resourcePathLabel = UILabel()
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
        
        resourcePathLabel.add(to: container).do {
            $0.leftToRight(of: stateView, offset: Theme.nameLeftOffset)
            $0.rightToSuperview()
            $0.top(to: stateView)
            $0.height(Theme.nameLabelHeight)
            
            $0.textAlignment = .left
            $0.font = Theme.nameLabelFont
            $0.textColor = .lightCoal
        }
        
        nameLabel.add(to: container).do {
            $0.left(to: resourcePathLabel)
            $0.rightToSuperview()
            $0.topToBottom(of: resourcePathLabel, offset: Theme.labelsTopOffset)
            $0.height(Theme.nameLabelHeight)
            
            $0.textAlignment = .left
            $0.font = Theme.nameLabelFont
            $0.textColor = .darkCoal
        }
        
        detailsLabel.add(to: container).do {
            $0.left(to: resourcePathLabel)
            $0.rightToSuperview()
            $0.topToBottom(of: nameLabel, offset: Theme.labelsTopOffset)
            $0.height()
            
            $0.textAlignment = .left
            $0.font = Theme.deailsLabelFont
            $0.textColor = .textGray
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        resourcePathLabel.text = nil
        nameLabel.text = nil
        stateView.do {
            $0.image = nil
            $0.tintColor = .clear
        }
    }
}

//MARK: - Configure Cell
extension PullRequestsCollectionCell: ConfigurableCell {
    typealias CellData = PullRequest
    
    func configure(with data: PullRequest) {
        let pullRequest = data
        
        setStateImage(state: pullRequest.state)
        
        if let baseRepository = pullRequest.baseRepository {
            resourcePathLabel.text = baseRepository.resourcePath
        }
        
        nameLabel.text = pullRequest.headRefName
        detailsLabel.text = makeDetailsDescription(for: pullRequest)
    }
    
    private func setStateImage(state: PullRequestState) {
        switch state {
        case .open:
            stateView.do {
                $0.image = Theme.prIcon.withRenderingMode(.alwaysTemplate)
                $0.tintColor = Theme.openedColor
            }
        case .merged:
            stateView.do {
                $0.image = Theme.mergeIcon.withRenderingMode(.alwaysTemplate)
                $0.tintColor = Theme.mergedColor
            }
        case .closed:
            stateView.do {
                $0.image = Theme.prIcon.withRenderingMode(.alwaysTemplate)
                $0.tintColor = Theme.closedColor
            }
        default:
            stateView.do {
                $0.image = nil
                $0.tintColor = .clear
            }
        }
    }
    
    private func makeDetailsDescription(for request: PullRequest) -> String {
        var details = "#\(request.number) by \(request.author)"
        
        if case .open = request.state {
            details = "#\(request.number) opened \(request.createdAt.timeAgo) by \(request.author)"
        } else if case .merged = request.state {
            details += request.mergedAt != nil ? " was merged \(request.mergedAt!.timeAgo)" : ""
        } else if case .closed = request.state {
            details += request.closedAt != nil ? " was closed \(request.closedAt!.timeAgo)" : ""
        }
        
        return details
    }
}

//MARK: - Theme
extension PullRequestsCollectionCell {
    enum Theme {
        // Icons
        static let prIcon: UIImage = #imageLiteral(resourceName: "pullRequest")
        static let mergeIcon: UIImage = #imageLiteral(resourceName: "merge")
        
        // Colors
        static let mergedColor: UIColor = #colorLiteral(red: 0.4352941176, green: 0.2588235294, blue: 0.7568627451, alpha: 1) // #6F42C1
        static let closedColor: UIColor = #colorLiteral(red: 0.7960784314, green: 0.137254902, blue: 0.1921568627, alpha: 1) // #CB2331
        static let openedColor: UIColor = #colorLiteral(red: 0.1529411765, green: 0.6549019608, blue: 0.2666666667, alpha: 1) // #27A744
        
        // Fonts
        static let nameLabelFont: UIFont = .circular(style: .book, size: 16.0)
        static let deailsLabelFont: UIFont = .circular(style: .medium, size: 13.0)
        static let labelMarkerFont: UIFont = .circular(style: .medium, size: 10.0)
        
        // Sizes
        static let stateImageSize = CGSize(17.0)
        static let nameLabelHeight: CGFloat = 19.0
        
       // Offsets
        static let stateLeftOffset: CGFloat = 13.0
        static let stateTopOffset: CGFloat = 8.0
        static let labelsTopOffset: CGFloat = 5.0
        static let nameLeftOffset: CGFloat = 5.0
    }
}

private extension Date {
    var isNow: Bool {
        guard let expirationDate = Calendar.current.date(byAdding: .minute, value: 10, to: self) else { return false }
        return expirationDate > Date()
    }
    
    var timeAgo: String {
        return DateUtilities.postedDateFormat(fromDate: self, toDate: Date())
    }
    
    var timeTo: String {
        return DateUtilities.postedDateFormat(fromDate: Date(), toDate: self)
    }
}
