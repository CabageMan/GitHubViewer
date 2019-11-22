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
        
        var tabBarViewFrame = tabBarView.frame
        tabBarViewFrame.size.height = TabBarView.Theme.tabItemHeight + .safeBottom
        tabBarViewFrame.origin.y = view.frame.size.height - tabBarViewFrame.size.height
        #warning("Check why we set frame and then set bounds")
        tabBarView.frame = tabBarViewFrame
        tabBarView.frame = tabBar.bounds
        tabBar.addSubview(tabBarView)
    }
}
