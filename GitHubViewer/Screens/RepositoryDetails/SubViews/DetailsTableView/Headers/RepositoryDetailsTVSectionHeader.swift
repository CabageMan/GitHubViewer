import UIKit

final class RepositoryDetailsTVSectionHeader: UITableViewHeaderFooterView {
    
    private let titleLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .mainBackground
        
        titleLabel.add(to: contentView).do {
            $0.leftToSuperview(offset: Theme.titleLeftOffset)
            $0.topToSuperview(offset: Theme.titleTopOffset)
            $0.height(Theme.titleHeight)
            
            $0.font = Theme.titleFont
            $0.textColor = .darkCoal
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}

//MARK: - Theme
extension RepositoryDetailsTVSectionHeader {
    enum Theme {
        // Fonts
        static let titleFont: UIFont = .circular(style: .bold, size: 17.0)
        
        // Sizes
        static let titleHeight: CGFloat = 19.0
    
        // Offsets
        static let titleLeftOffset: CGFloat = 15.0
        static let titleTopOffset: CGFloat = 10.0
    }
}
