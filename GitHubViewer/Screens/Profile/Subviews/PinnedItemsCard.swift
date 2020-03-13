import UIKit

final class PinnedItemsCard: UIView {
    
    private let collection = GitHubViewerCollection<ProfilePinnedCell>(mode: .profile)
    private var heightConstraint: NSLayoutConstraint!
    
    var pinnedItems: [ProfilePinnedItem] = [] {
        didSet {
            heightConstraint.constant = CGFloat(pinnedItems.count) * 70.0 + 20.0
            collection.items = pinnedItems
        }
    }
    var itemDidSelect: (ProfilePinnedItem) -> Void = { _ in }
    
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
        heightConstraint = self.height(0.0)
        collection.collectionView.add(to: self).do {
            $0.edgesToSuperview(excluding: [.left, .right])
            $0.leftToSuperview(offset: Theme.sideOffset)
            $0.rightToSuperview(offset: -Theme.sideOffset)
            $0.isScrollEnabled = false
            $0.alwaysBounceVertical = false
            $0.alwaysBounceHorizontal = false
        }
        collection.onCellTap = { [weak self] item in
            self?.itemDidSelect(item)
        }
    }
}

//MARK: - Theme
extension PinnedItemsCard {
    enum Theme {
        static let sideOffset: CGFloat = 10.0
    }
}
