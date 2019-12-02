import UIKit

final class RepositoryDetailsTVLinkCell: UITableViewCell {
    private let linkLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    //MARK: - Actions
    private func setup() {
        linkLabel.add(to: contentView).do {
            $0.leftToSuperview(offset: Theme.linkLeftOffset)
            $0.rightToSuperview()
            $0.topToSuperview(offset: Theme.linkTopOffset)
            $0.height(Theme.linkHeight)
            
            $0.font = Theme.linkFont
            $0.textColor = .textDarkBlue
        }
    }
    
    func configure(link: String) {
        linkLabel.text = link
    }
}

//MARK: - Theme
extension RepositoryDetailsTVLinkCell {
    enum Theme {
        // Fonts
        static let linkFont: UIFont = .circular(style: .bold, size: 14.0)
        
        // Sizes
        static let linkHeight: CGFloat = 15.0
        
        // Offsets
        static let linkLeftOffset: CGFloat = 15.0
        static let linkTopOffset: CGFloat = 10.0
    }
}
