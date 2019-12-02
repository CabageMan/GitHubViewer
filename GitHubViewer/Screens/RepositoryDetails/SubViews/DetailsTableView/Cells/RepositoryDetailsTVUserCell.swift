import UIKit

final class RepositoryDetailsTVUserCell: UITableViewCell {
    
    var cellTapped: (User) -> Void = { _ in }
    
    private let avatarView = UIImageView()
    private let nameLabel = UILabel()
    private let loginLabel = UILabel()
    
    private var user: User?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    //MARK: - Actions
    private func setup() {
        nameLabel.add(to: contentView).do {
            $0.leftToSuperview(offset: Theme.nameLeftOffset)
            $0.rightToSuperview()
            $0.topToSuperview(offset: Theme.nameTopOffset)
            $0.height(Theme.nameHeight)
            
            $0.font = Theme.titleFont
            $0.textColor = .darkCoal
        }
    }
    
    func configure(user: User) {
        nameLabel.text = user.name
        self.user = user
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        guard let selectedUser = user, selected else { return }
        cellTapped(selectedUser)
    }
}

//MARK: - Theme
extension RepositoryDetailsTVUserCell {
    enum Theme {
        // Fonts
        static let titleFont: UIFont = .circular(style: .bold, size: 14.0)
        static let detailsFont: UIFont = .circular(style: .book, size: 13.0)
        
        // Sizes
        static let nameHeight: CGFloat = 15.0
        
        
        // Offsets
        static let nameLeftOffset: CGFloat = 15.0
        static let nameTopOffset: CGFloat = 10.0
    }
}
