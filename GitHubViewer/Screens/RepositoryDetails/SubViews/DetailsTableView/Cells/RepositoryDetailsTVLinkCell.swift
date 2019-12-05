import UIKit

final class RepositoryDetailsTVLinkCell: UITableViewCell {
    
    var cellTapped: (String) -> Void = { _ in }
    
    private let linkLabel = UILabel()
    private let arrowView = UIImageView()
    
    private var link = String()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    //MARK: - Actions
    private func setup() {
        arrowView.add(to: contentView).do {
            $0.rightToSuperview(offset: -Theme.arrowRightOffset)
            $0.centerYToSuperview()
            $0.size(Theme.arrowSize)
            
            $0.contentMode = .scaleAspectFit
            $0.image = #imageLiteral(resourceName: "chevronRight20")
        }
        linkLabel.add(to: contentView).do {
            $0.leftToSuperview(offset: Theme.linkLeftOffset)
            $0.rightToLeft(of: arrowView, offset: -Theme.linkRightOffset)
            $0.centerYToSuperview()
            $0.height(Theme.linkHeight)
            
            $0.font = Theme.linkFont
            $0.textColor = .textDarkBlue
        }
    }
    
    func configure(link: String) {
        linkLabel.text = link
        self.link = link
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected { cellTapped(link) }
    }
    
    override func prepareForReuse() {
        link = ""
        linkLabel.text = nil
    }
}

//MARK: - Theme
extension RepositoryDetailsTVLinkCell {
    enum Theme {
        // Fonts
        static let linkFont: UIFont = .circular(style: .bold, size: 14.0)
        
        // Sizes
        static let linkHeight: CGFloat = 15.0
        static let arrowSize: CGSize = CGSize(20.0)
        
        // Offsets
        static let linkLeftOffset: CGFloat = 25.0
        static let linkRightOffset: CGFloat = 5.0
        static let arrowRightOffset: CGFloat = 5.0
    }
}
