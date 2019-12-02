import UIKit

final class RepositoryDetailsTVInfoCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let detailsLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    //MARK: - Actions
    private func setup() {
        titleLabel.add(to: contentView).do {
            $0.leftToSuperview(offset: Theme.titleLeftOffset)
            $0.rightToSuperview()
            $0.topToSuperview(offset: Theme.titleTopOffset)
            $0.height(Theme.titleHeight)
            
            $0.font = Theme.titleFont
            $0.textColor = .darkCoal
        }
        
        detailsLabel.add(to: contentView).do {
            $0.left(to: titleLabel)
            $0.rightToSuperview()
            $0.topToBottom(of: titleLabel, offset: Theme.detailsTopOffset)
            $0.height(Theme.detailsHeight)
            
            $0.font = Theme.detailsFont
            $0.textColor = .lightCoal
        }
    }
    
    func configure(title: String, info: String) {
        titleLabel.text = title
        detailsLabel.text = info
    }
}

//MARK: - Theme
extension RepositoryDetailsTVInfoCell {
    enum Theme {
        // Fonts
        static let titleFont: UIFont = .circular(style: .bold, size: 14.0)
        static let detailsFont: UIFont = .circular(style: .book, size: 13.0)
        
        // Sizes
        static let titleHeight: CGFloat = 15.0
        static let detailsHeight: CGFloat = 15.0
        
        // Offsets
        static let titleLeftOffset: CGFloat = 15.0
        static let titleTopOffset: CGFloat = 10.0
        static let detailsTopOffset: CGFloat = 10.0
    }
}
