import UIKit

final class TabBarView: UIView {
    //MARK: - Tab
    enum Tab: Int {
        case repositories
        case pullRequests
        case issues
        
        var normalImage: UIImage? {
            switch self {
            case .repositories: return #imageLiteral(resourceName: "repository")
            case .pullRequests: return #imageLiteral(resourceName: "pullRequest")
            case .issues: return #imageLiteral(resourceName: "issue")
            }
        }
        
        var title: String? {
            switch self {
            case .repositories: return String.Repos.title
            case .pullRequests: return String.Pr.title
            case .issues: return String.Issues.title
            }
        }
        
        static let all: [Tab] = [.repositories, .pullRequests, .issues]
    }
    
    //MARK: - Tab Bar Item
    final class TabItem: UIView {
        let tab: Tab
        private let imageView: UIImageView
        private let selectedImageView: UIImageView
        private let titleLabel: UILabel
        
        init(tab: Tab) {
            self.tab = tab
            imageView = UIImageView(image: tab.normalImage)
            selectedImageView = UIImageView(image: tab.normalImage?.withRenderingMode(.alwaysTemplate))
            titleLabel = UILabel()
            titleLabel.text = tab.title
            super.init(frame: .zero)
            
            setup()
        }
        
        required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
        
        private func setup() {
            imageView.add(to: self).do {
                $0.centerXToSuperview()
                $0.centerYToSuperview(offset: -Theme.tabBarItemPadding)
            }
            
            selectedImageView.add(to: self).do {
                $0.centerXToSuperview()
                $0.centerYToSuperview(offset: -Theme.tabBarItemPadding)
                $0.tintColor = .selectedFieldBorder
                $0.alpha = 0
            }
            
            titleLabel.add(to: self).do {
                $0.centerXToSuperview()
                $0.bottomToSuperview(offset: -Theme.tabBarItemPadding)
                $0.font = Theme.itemNormalFont
                $0.textColor = .darkCoal
            }
        }
        
        //MARK: - Tab Bar Item Actions
        func setSelected(_ selected: Bool) {
            DispatchQueue.main.async { [weak self] in
                self?.titleLabel.fadeTransition(duration: Theme.selectingAnimationDuration)
                self?.titleLabel.textColor = selected ? .selectedFieldBorder : .darkCoal
                self?.titleLabel.font = selected ? Theme.itemSelectedFont : Theme.itemNormalFont
                
                #warning("Add moving image to top animation")
                UIView.animate(withDuration: Theme.selectingAnimationDuration) {
                    self?.imageView.alpha = selected ? 0 : 1
                    self?.selectedImageView.alpha = selected ? 1 : 0
                }
            }
        }
    }
    
    //MARK: - Properties
    let tabs: [Tab]
    private(set) var selectedTab: Tab?
    private var items: [TabItem] = []
    
    var onTabTap: (Tab) -> Void = { _ in }
 
    //MARK: - Initializers
    required init(tabs: [Tab]) {
        self.tabs = tabs
        selectedTab = tabs.first
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    //MARK: - Acctions
    private func setupUI() {
        backgroundColor = .textGray
        
        let container = UIView().add(to: self).then {
            $0.edgesToSuperview(excluding: .bottom)
            $0.height(Theme.tabHeight)
        }
        
        let stackView = UIStackView().add(to: container).then {
            $0.edgesToSuperview(excluding: .bottom)
            $0.height(Theme.tabItemHeight)
            $0.alignment = .fill
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 0
        }
        
        tabs.forEach { tab in
            TabItem(tab: tab).add(to: stackView).do {
                $0.tintColor = .selectedFieldBorder
                items.append($0)
                $0.addGesture(type: .tap) { [weak self] _ in  self?.onTabTap(tab) }
            }
        }
    }
    
    func select(tab selectedTab: Tab, animated: Bool = true) {
        items.forEach { $0.setSelected($0.tab == selectedTab) }
        self.selectedTab = selectedTab
    }
}

//MARK: - Theme
extension TabBarView {
    enum Theme {
        // Fonts
        static let itemNormalFont: UIFont = .circular(style: .medium, size: 10)
        static let itemSelectedFont: UIFont = .circular(style: .bold, size: 10)
        
        // Sizes
        static let tabHeight: CGFloat = 60.0
        static let tabItemHeight: CGFloat = 50.0
        
        // Offsets
        static let tabBarItemPadding: CGFloat = 5.0
        
        // Timing
        static let selectingAnimationDuration: TimeInterval = 0.2
    }
}
