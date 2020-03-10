import UIKit

final class ProfileCollectionCell: UICollectionViewCell {
    
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
    
    //MARK: - Actions
    private func setup() {
        contentView.backgroundColor = .clear
        
        container.add(to: contentView).do {
            $0.edgesToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        container.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
}

//MARK: - Configure  Cell
extension ProfileCollectionCell: ConfigurableCell {
    typealias CellData = ProfileItem
    
    func configure(with data: ProfileItem) {
        switch data {
        case .user(let user):
            configureUserContent(user: user)
        case .pinned(let pinnedItems):
            configurePinnedContent(items: pinnedItems)
        case .contributions(let contributions):
            configureContributionsChart(contributions: contributions)
        default: break
        }
    }
    
    private func configureUserContent(user: User) {
        UserCard().add(to: container).do {
            $0.topToSuperview(offset: Theme.contentSideOffset)
            $0.leftToSuperview(offset: Theme.contentSideOffset)
            $0.rightToSuperview(offset: -Theme.contentSideOffset)
            $0.bottomToSuperview(offset: -Theme.contentSideOffset)
            $0.configure(with: user)
        }
    }
    
    private func configurePinnedContent(items: ProfileItem.PinnedItems) {
        log("-----\n")
        log("Pinned Repositories")
        items.repositories.forEach { repository in log("Repository Name: \(repository.name)") }
        log("\nPinned Items:")
        items.gists.forEach { gist in log("Gist Name \(gist.name)") }
    }
    
    private func configureContributionsChart(contributions: [ProfileItem.ContributionDay]) {
        log("-----\n")
        log("Contributions Days:")
        contributions.forEach { day in log("Contribution: \(day.weekday)") }
    }
}

//MARK: - Theme
extension ProfileCollectionCell {
    enum Theme {
        //Offsets
        static let contentSideOffset: CGFloat = 13.0
    }
}
