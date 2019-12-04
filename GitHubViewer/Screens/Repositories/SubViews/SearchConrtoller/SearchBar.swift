import UIKit

final class SearchBar: UISearchBar {
    
    var textFont: UIFont = Theme.textFieldFont
    var textColor: UIColor = .white
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

//MARK: - Theme
extension SearchBar {
    enum Theme {
        // Fonts
        static let textFieldFont: UIFont = .circular(style: .book, size: 13.0)
    }
}
