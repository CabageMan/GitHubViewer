import UIKit

final class TabBarViewController: UITabBarController {
    
    private let tabBarView = TabBarView(tabs: TabBarView.Tab.all)
    var tabs: [TabBarView.Tab] {
        return tabBarView.tabs
    }
    
    var onTabSelect: (TabBarView.Tab) -> Void = { _ in }
    
    override var selectedIndex: Int {
        didSet {
            guard let tab = tabs.at(selectedIndex) else { return }
            tabBarView.select(tab: tab)
        }
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isTranslucent = true
        tabBarView.onTabTap = { [weak self] tab in self?.onTabSelect(tab) }
    }
    
    override func  viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tabBarView.frame = tabBar.bounds
        tabBar.addSubview(tabBarView)
    }
}
