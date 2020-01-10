import UIKit

final class IssueCollectionCell: UICollectionViewCell {
    
    private let container = UIView()
    private let titleLabel = UILabel()
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    //MARK: - Actions
    private func setup() {
        contentView.backgroundColor = .clear
        
        container.add(to: contentView).do {
            $0.edgesToSuperview()
            $0.backgroundColor = .white
        }
        
        UIView().add(to: container).do {
            $0.edgesToSuperview(excluding: .bottom)
            $0.height(1.0)
            $0.backgroundColor = .mainBackground
        }
        
        titleLabel.add(to: container).do {
            $0.leftToSuperview(offset: Theme.titleLeftOffset)
            $0.rightToSuperview()
            $0.centerYToSuperview()
            $0.height(Theme.titleHeight)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
    }
}

//MARK: - Configure Cell
extension IssueCollectionCell: ConfigurableCell {
    typealias CellData = Issue
    
    func configure(with data: Issue) {
        let issue = data
        
        titleLabel.text = issue.title
    }
}

//MARK: - Theme
extension IssueCollectionCell {
    enum Theme {
        // Sizes
        static let titleHeight: CGFloat = 15.0
        
        // Offsets
        static let titleLeftOffset: CGFloat = 8.0
    }
}
