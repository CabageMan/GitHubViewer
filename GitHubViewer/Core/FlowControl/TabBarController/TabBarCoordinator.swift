import UIKit

final class TabBarCoordinator: Coordinator {
    
    enum DeepLink {
        // Here we can set up deep links like in AppCoordinator
    }
    
    let tabBarViewController = TabBarViewController()
    private let window: UIWindow
    
    // Coordinators
    let reposCoordinator: ReposCoordinator
    let prCoordinator: PRCoordinator
    let issuesCoordinator: IssuesCoordinator
    
    init(window: UIWindow) {
        self.window = window
        reposCoordinator = ReposCoordinator()
        prCoordinator = PRCoordinator()
        issuesCoordinator = IssuesCoordinator()
        super.init()
    
        addChild(reposCoordinator)
        addChild(prCoordinator)
        addChild(issuesCoordinator)
        
        tabBarViewController.viewControllers = [
            reposCoordinator.rootVC,
            prCoordinator.rootVC,
            issuesCoordinator.rootVC
        ]
        
        tabBarViewController.onTabSelect = { [weak self] tab in
            switch tab {
            case .repositories: self?.runReposFlow()
            case .pullRequests: self?.runPRFlow()
            case .issues: self?.runIssueFlow()
            }
        }
    }
    
    //MARK: - Actions
    func start(deepLink: TabBarCoordinator.DeepLink? = nil) {
        window.switchRootViewController(tabBarViewController)
        window.makeKeyAndVisible()
        runReposFlow()
        
        reposCoordinator.start()
        prCoordinator.start()
        issuesCoordinator.start()
    }
    
    private func runReposFlow(_ deepLink: ReposCoordinator.DeepLink? = nil) {
        if tabBarViewController.selectedIndex != TabBarView.Tab.repositories.rawValue {
            tabBarViewController.selectedIndex = TabBarView.Tab.repositories.rawValue
        } else {
            reposCoordinator.handleSecondTabTap()
        }
    }
    
    private func runPRFlow(_ deepLink: PRCoordinator.DeepLink? = nil) {
        if tabBarViewController.selectedIndex != TabBarView.Tab.pullRequests.rawValue {
            tabBarViewController.selectedIndex = TabBarView.Tab.pullRequests.rawValue
        } else {
            prCoordinator.handleSecondTabTap()
        }
    }
    
    private func runIssueFlow(_ deepLink: IssuesCoordinator.DeepLink? = nil) {
        if tabBarViewController.selectedIndex != TabBarView.Tab.issues.rawValue {
            tabBarViewController.selectedIndex = TabBarView.Tab.issues.rawValue
        } else {
            issuesCoordinator.handleSecondTabTap()
        }
    }
}
