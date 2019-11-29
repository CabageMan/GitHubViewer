import UIKit

final class RepositoriesCollectionHeader: UICollectionReusableView {
    
    let searchField = BarTextField.createRepoSearchField()
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
        container.add(to: self).do {
            $0.edgesToSuperview(excluding: .bottom)
            $0.height(Theme.containerHeight)
            
            $0.backgroundColor = .barBlack
        }
        
        searchField.textField.add(to: container).do {
            $0.leftToSuperview(offset: Theme.searchFieldSideOffset)
            $0.rightToSuperview(offset: -Theme.searchFieldSideOffset)
            $0.topToSuperview(offset: Theme.searchFieldTopOffset)
            $0.height(Theme.searchFieldHeight)
        }
    }
}

//MARK: - Theme
extension RepositoriesCollectionHeader {
    enum Theme {
        // Sizes
        static let containerHeight: CGFloat = 45.0
        static let searchFieldHeight: CGFloat = 35.0
        
        // Offsets
        static let searchFieldSideOffset: CGFloat = 16.0
        static let searchFieldTopOffset: CGFloat = 5.0
    }
}
