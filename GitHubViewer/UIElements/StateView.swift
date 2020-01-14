import UIKit

final class StateView: UIView {
    
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private var titleWidth: CGFloat
    private var selectorWidth: CGFloat
    
    init(mode: Mode) {
        self.titleWidth = mode.title.getWidth(with: Theme.titleFont).rounded(.up)
        self.selectorWidth = Theme.selectorOffsetsSum + mode.title.getWidth(with: Theme.titleFont).rounded(.up)
        super.init(frame: .zero)
        setupUI(mode: mode)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    //MARK: - Actions
    private func setupUI(mode: Mode) {
        isUserInteractionEnabled = true
        iconView.add(to: self).do {
            $0.leftToSuperview(offset: Theme.iconLeftOffset)
            $0.centerYToSuperview()
            $0.size(Theme.iconSize)
            $0.contentMode = .scaleAspectFit
            $0.image = mode.icon.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .darkCoal
        }
        
        titleLabel.add(to: self).do {
            $0.leftToRight(of: iconView, offset: Theme.titleLeftOffset)
            $0.centerYToSuperview()
            $0.size(CGSize(width: titleWidth, height: Theme.titleHeight))
            $0.textAlignment = .left
            $0.font = Theme.titleFont
            $0.textColor = .darkCoal
            $0.text = mode.title
        }
        
        switch mode {
        case .open: setColoredView(with: Theme.openColor)
        case .merged: setColoredView(with: Theme.mergedColor)
        case .closed: setColoredView(with: Theme.closedColor)
        default: break
        }
        
        width(selectorWidth)
    }
    
    private func setColoredView(with color: UIColor) {
        iconView.tintColor = .white
        titleLabel.textColor = .white
        backgroundColor = color
        layer.cornerRadius = Theme.cornerRadius
        isUserInteractionEnabled = false
    }
    
    func setSelected(isSelected: Bool) {
        iconView.tintColor = isSelected ? .darkCoal : .textGray
        titleLabel.textColor = isSelected ? .darkCoal : .textGray
    }
    
    func changeIcon(with mode: Mode) {
        iconView.image = mode.icon.withRenderingMode(.alwaysTemplate)
    }
}

//MARK: - Mode
extension StateView {
    enum Mode {
        case requestOpen
        case issueOpen
        case completed
        case open
        case merged
        case closed
        case unknown
        
        var icon: UIImage {
            switch self {
            case .requestOpen, .open, .closed: return #imageLiteral(resourceName: "pullRequest")
            case .issueOpen: return #imageLiteral(resourceName: "openIssue")
            case .completed: return #imageLiteral(resourceName: "checkmark")
            case .merged: return #imageLiteral(resourceName: "merge")
            case .unknown: return UIImage()
            }
        }
        
        var title: String {
            switch self {
            case .open, .requestOpen, .issueOpen: return String.General.open
            case .completed, .closed: return String.General.closed
            case .merged: return String.Pr.merged
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
