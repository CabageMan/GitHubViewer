import UIKit

final class CollectionSelectorHeader: UICollectionReusableView {
    #warning("May be make it generic for issue collection")
    var selector: PullRequestState = .open {
        didSet {
            switch selector {
            case .open:
                closedView.setSelected(isSelected: false)
                openView.setSelected(isSelected: true)
            case .closed:
                openView.setSelected(isSelected: false)
                closedView.setSelected(isSelected: true)
            default: return
            }
            onSelectorChanged()
        }
    }
    
    var onSelectorChanged: () -> Void = { }
    
    private let openView = SelectorView(icon: #imageLiteral(resourceName: "pullRequest"), title: String.General.open)
    private let closedView = SelectorView(icon: #imageLiteral(resourceName: "checkmark"), title: String.General.closed)
    
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
        openView.add(to: self).do {
            $0.leftToSuperview(offset: Theme.selectorLeftOffset)
            $0.topToSuperview(offset: Theme.selectorTopOffset)
            $0.width(Theme.selectorViewWidth)
            $0.height(Theme.selectorViewHeight)
            $0.setSelected(isSelected: true)
            $0.addGesture(type: .tap) { [weak self] _ in self?.selector = .open }
        }
        closedView.add(to: self).do {
            $0.leftToRight(of: openView)
            $0.topToSuperview(offset: Theme.selectorTopOffset)
            $0.width(Theme.selectorViewWidth)
            $0.height(Theme.selectorViewHeight)
            $0.setSelected(isSelected: false)
            $0.addGesture(type: .tap) { [weak self] _ in self?.selector = .closed }
        }
    }
}

//MARK: - Theme
extension CollectionSelectorHeader {
    enum Theme {
        // Sizes
        static let headerHeight: CGFloat = 40.0
        static let selectorViewWidth: CGFloat = 70.0
        static let selectorViewHeight: CGFloat = 30.0
        
        // Offsets
        static let selectorTopOffset: CGFloat = 15.0
        static let selectorLeftOffset: CGFloat = 13.0
    }
}
