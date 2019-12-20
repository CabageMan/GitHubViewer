import UIKit

final class SideMenuCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let arrowView = UIImageView()
    
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
        
        titleLabel.add(to: contentView).do {
            $0.edgesToSuperview(insets: UIEdgeInsets(value: Theme.titleOffset))
            
            $0.font = Theme.titleFont
        }
    }
    
    func configure(title: String, isSelectable: Bool = true) {
        titleLabel.text = title
        if !isSelectable {
            arrowView.isHidden = true
            isUserInteractionEnabled = false
        }
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        arrowView.isHidden = false
        isUserInteractionEnabled = true
    }
}

//MARK: - Theme
extension SideMenuCell {
    enum Theme {
        // Fonts
        static let titleFont: UIFont = .circular(style: .medium, size: 17.0)
        
        // Sizes
        static let arrowSize: CGSize = CGSize(20.0)
        
        // Offsets
        static let titleOffset: CGFloat = 15.0
        static let arrowRightOffset: CGFloat = 5.0
    }
}
