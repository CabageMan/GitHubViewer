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

//func showTabBar(animated: Bool = true, completion: (() -> Void)? = nil) {
//  tabBarState = .normal
//  tabBar.layer.removeAllAnimations()
//  
//  if animated {
//    tabBar.isHidden = false
//    UIView.animate(withDuration: 0.25, delay: 0, options: [.beginFromCurrentState], animations: {
//      self.tabBar.transform = .identity
//    }, completion: { _ in completion?() })
//  } else {
//    tabBar.isHidden = false
//    tabBar.transform = .identity
//  }
//}
//
//func hideTabBar(animated: Bool = true, completion: (() -> Void)? = nil) {
//  tabBarState = .hidden
//  tabBar.layer.removeAllAnimations()
//
//  if animated {
//    UIView.animate(withDuration: 0.25, delay: 0, options: [.beginFromCurrentState], animations: {
//      self.tabBar.transform = CGAffineTransform(translationX: 0, y: self.tabBar.bounds.size.height)
//    }, completion: { isFinished in
//      guard isFinished else { return }
//      self.tabBar.isHidden = true //hide tab bar to support view controller transform scale animations
//      completion?()
//    })
//  } else {
//    tabBar.transform = CGAffineTransform(translationX: 0, y: self.tabBar.bounds.size.height)
//    tabBar.isHidden = true
//  }
//}
