import UIKit

final class StateView: UIView {
    
    private var mode: Mode
    
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private var titleWidth: CGFloat {
        return mode.title.getWidth(with: Theme.titleFont).rounded(.up)
    }
    private var selectorWidth: CGFloat {
        return Theme.selectorOffsetsSum + mode.title.getWidth(with: Theme.titleFont).rounded(.up)
    }
    private var titleWidthConstraint: NSLayoutConstraint!
    private var selectorWidthConstraint: NSLayoutConstraint!
    
    init(mode: Mode) {
        self.mode = mode
        super.init(frame: .zero)
        setupUI()
        configure()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    //MARK: - Private Methods
    private func setupUI() {
        isUserInteractionEnabled = true
        iconView.add(to: self).do {
            $0.leftToSuperview(offset: Theme.iconLeftOffset)
            $0.centerYToSuperview()
            $0.size(Theme.iconSize)
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .darkCoal
        }
        
        titleLabel.add(to: self).do {
            $0.leftToRight(of: iconView, offset: Theme.titleLeftOffset)
            $0.centerYToSuperview()
            titleWidthConstraint = $0.width(titleWidth)
            $0.height(Theme.titleHeight)
            $0.textAlignment = .left
            $0.font = Theme.titleFont
            $0.textColor = .darkCoal
        }
        
        selectorWidthConstraint = width(selectorWidth)
    }
    
    private func configure() {
        titleWidthConstraint.constant = titleWidth
        selectorWidthConstraint.constant = selectorWidth
        iconView.image = mode.icon.withRenderingMode(.alwaysTemplate)
        titleLabel.text = mode.title
        switch mode {
        case .requestDetailsOpen, .issueDetailsOpen: setColoredView(with: Theme.openColor)
        case .requestDetailsMerged: setColoredView(with: Theme.mergedColor)
        case .requestDetailsClosed, .issueDetailsClosed: setColoredView(with: Theme.closedColor)
        default: break
        }
    }
    
    private func setColoredView(with color: UIColor) {
        iconView.tintColor = .white
        titleLabel.textColor = .white
        backgroundColor = color
        layer.cornerRadius = Theme.cornerRadius
        isUserInteractionEnabled = false
    }
    
    //MARK: - Public Methods
    func setSelected(isSelected: Bool) {
        iconView.tintColor = isSelected ? .darkCoal : .textGray
        titleLabel.textColor = isSelected ? .darkCoal : .textGray
    }
    
    func changeMode(to mode: Mode) {
        self.mode = mode
        configure()
    }
}

//MARK: - Mode
extension StateView {
    enum Mode {
        case requestOpen
        case issueOpen
        case completed
        case requestDetailsOpen
        case requestDetailsMerged
        case requestDetailsClosed
        case issueDetailsOpen
        case issueDetailsClosed
        case unknown
        
        var icon: UIImage {
            switch self {
            case .requestOpen, .requestDetailsOpen, .requestDetailsClosed: return #imageLiteral(resourceName: "pullRequest")
            case .issueOpen, .issueDetailsOpen, .issueDetailsClosed: return #imageLiteral(resourceName: "openIssue")
            case .completed: return #imageLiteral(resourceName: "checkmark")
            case .requestDetailsMerged: return #imageLiteral(resourceName: "merge")
            case .unknown: return UIImage()
            }
        }
        
        var title: String {
            switch self {
            case .requestDetailsOpen, .requestOpen, .issueDetailsOpen, .issueOpen: return String.General.open
            case .completed, .requestDetailsClosed, .issueDetailsClosed: return String.General.closed
            case .requestDetailsMerged: return String.Pr.merged
            case .unknown: return ""
            }
        }
    }
}

//MARK: - Theme
extension StateView {
    enum Theme {
        // Fonts
        static let titleFont: UIFont = .circular(style: .medium, size: 13.0)
        
        // Colors
        static var openColor: UIColor { return PullRequestsCollectionCell.Theme.openedColor }
        static var mergedColor: UIColor { return PullRequestsCollectionCell.Theme.mergedColor }
        static var closedColor: UIColor { return PullRequestsCollectionCell.Theme.closedColor }
        
        // Sizes
        static let iconSize = CGSize(17.0)
        static let titleHeight: CGFloat = 17.0
        static let cornerRadius: CGFloat = 3.0
        
        // Offsets
        static let iconTopOffset: CGFloat = 8.0
        static let iconLeftOffset: CGFloat = 7.0
        static let titleLeftOffset: CGFloat = 3.0
        static let titleRightOffset: CGFloat = 7.0
        static let selectorOffsetsSum: CGFloat = iconLeftOffset + iconSize.width + titleLeftOffset + titleRightOffset
    }
}
