import UIKit

final class RepositoryCollectionHeader: UICollectionReusableView {
    
    let searchField = TitledTextField.createRepoSearchField()
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    #warning("Finish Header. Add new collection layout.")
    private func setup() {
        searchField.add(to: self).do {
            $0.leftToSuperview(offset: Theme.searchFieldSideOffset)
            $0.rightToSuperview(offset: -Theme.searchFieldSideOffset)
            $0.topToSuperview(offset: Theme.searchFieldTopOffset)
        }
    }
}

//MARK: - Theme
extension RepositoryCollectionHeader {
    enum Theme {
        // Sizes
        static let searchFieldHeight: CGFloat = 40.0
        
        // Offsets
        static let searchFieldTopOffset: CGFloat = 5.0
        static let searchFieldSideOffset: CGFloat = 16.0
    }
}
