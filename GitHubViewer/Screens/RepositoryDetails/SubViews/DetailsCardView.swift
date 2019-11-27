import UIKit

final class DetailsCardView: UIView {
    struct InfoItem {
        let title: String
        let details: String
    }
    
    struct LinkItem {
        let title: String
        let action: () -> Void
    }
    
    struct ListItem {
        enum InfoType {
            case users([User])
        }
        let title: String
        let type: InfoType
    }
    
    private let title: String
    private let infoItems: [InfoItem]
    private let linkItems: [LinkItem]
    private let listItems: [ListItem]
    
    //MARK: - Initializers
    init(title: String, infoItems: [InfoItem] = [], linkItems: [LinkItem] = [], listItems: [ListItem] = []) {
        self.title = title
        self.infoItems = infoItems
        self.linkItems = linkItems
        self.listItems = listItems
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    //MARK: - Actions
    private func setup() {
        var infoHeightConstraint: NSLayoutConstraint!
        var previousCell: UIView?
        
        let titleLabel = UILabel().add(to: self).then {
            $0.leftToSuperview(offset: Theme.titleLeftOffset)
            $0.topToSuperview(offset: Theme.titleTopOffset)
            $0.height(Theme.titleHeight)
            $0.font = Theme.titleFont
            $0.text = title
            $0.numberOfLines = 0
        }
        
        let infoContainer = UIView().add(to: self).then {
            $0.leftToSuperview(offset: Theme.itemsSideOffset)
            $0.rightToSuperview(offset: -Theme.itemsSideOffset)
            $0.topToBottom(of: titleLabel, offset: Theme.itemsVerticalOffset)
            infoHeightConstraint = $0.height(0.0)
            
            $0.backgroundColor = .white
            $0.layer.cornerRadius = .defaultCornerRadius
            $0.clipsToBounds = true
        }
        
        for item in infoItems {
            createInfoCell(item: item).add(to: infoContainer).do {
                
                if previousCell == nil {
                    $0.topToSuperview()
                    infoHeightConstraint.constant += Theme.itemHeight
                } else {
                    $0.topToBottom(of: previousCell!, offset: Theme.itemsOffset)
                    infoHeightConstraint.constant += Theme.itemHeight + Theme.itemsOffset
                }
                $0.leftToSuperview()
                $0.rightToSuperview()
                $0.height(Theme.itemHeight)
                previousCell = $0
            }
        }
    }
    
    private func createInfoCell(item: InfoItem) -> UIView {
        let container = UIView()
        let titleLabel = UILabel().add(to: container).then {
            $0.edgesToSuperview(excluding: .bottom)
            $0.height(Theme.itemLabelHeight)
            $0.font = Theme.itemFont
            $0.text = item.title
        }
        
        UILabel().add(to: container).do {
            $0.edgesToSuperview(excluding: [.top, .bottom])
            $0.topToBottom(of: titleLabel, offset: Theme.itemLabelsOffset)
            $0.height(Theme.itemLabelHeight)
            $0.font = Theme.itemFont
            $0.text = item.details
        }
        return container
    }
}

//MARK: - Theme
extension DetailsCardView {
    enum Theme {
        // Fonts
        static let titleFont: UIFont = .circular(style: .bold, size: 17.0)
        static let itemFont: UIFont = .circular(style: .book, size: 13.0)
        
        // Sizes
        static let titleHeight: CGFloat = 20.0
        static let itemLabelHeight: CGFloat = 15.0
        static let itemHeight: CGFloat = 40.0
        
        // Offsets
        static let titleLeftOffset: CGFloat = 10.0
        static let titleTopOffset: CGFloat = 30.0
        static let itemsSideOffset: CGFloat = 15.0
        static let itemsVerticalOffset: CGFloat = 10.0
        static let itemLabelsOffset: CGFloat = 5.0
        static let itemsOffset: CGFloat = 10.0
    }
}
