import UIKit

final class RepositoriesCollectionHeader: UICollectionReusableView {
    
    let searchField = TitledTextField.createRepoSearchField()
    private let container = UIView()
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        dropShadow()
        
        container.add(to: self).do {
            $0.edgesToSuperview(excluding: .bottom)
            $0.height(Theme.containerHeight)
            
            $0.backgroundColor = .white
            $0.layer.cornerRadius = .defaultCornerRadius
            $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            $0.clipsToBounds = true
        }
        
        searchField.add(to: container).do {
            $0.leftToSuperview(offset: Theme.searchFieldSideOffset)
            $0.rightToSuperview(offset: -Theme.searchFieldSideOffset)
            $0.topToSuperview(offset: Theme.searchFieldTopOffset)
        }
    }
}

//MARK: - Theme
extension RepositoriesCollectionHeader {
    enum Theme {
        // Sizes
        static let containerHeight: CGFloat = 97.0
        static let searchFieldHeight: CGFloat = 40.0
        
        // Offsets
        static let searchFieldTopOffset: CGFloat = 5.0
        static let searchFieldSideOffset: CGFloat = 16.0
    }
}
