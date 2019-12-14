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

//MARK: - Actions
extension TabBarViewController {
    func showTabBar(animated: Bool = true, completion: (() -> Void)? = nil) {
      tabBar.layer.removeAllAnimations()
      
      if animated {
        tabBar.isHidden = false
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: [.beginFromCurrentState],
            animations: { [weak self] in
                self?.tabBar.transform = .identity
            },
            completion: { _ in completion?() }
        )
      } else {
        tabBar.do {
            $0.isHidden = false
            $0.transform = .identity
        }
      }
    }

    func hideTabBar(animated: Bool = true, completion: (() -> Void)? = nil) {
      tabBar.layer.removeAllAnimations()

      if animated {
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: [.beginFromCurrentState],
            animations: { [weak self] in
                guard let self = self else { return }
                self.tabBar.transform = CGAffineTransform(translationX: 0, y: self.tabBar.bounds.size.height)
            },
            completion: { [weak self] isFinished in
                guard let self = self, isFinished else { return }
                self.tabBar.isHidden = true
                completion?()
            }
        )
      } else {
        tabBar.do {
            $0.transform = CGAffineTransform(translationX: 0, y: tabBar.bounds.size.height)
            $0.isHidden = true
        }
      }
    }
}
