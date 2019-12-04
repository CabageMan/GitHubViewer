import UIKit

final class TabBarCoordinator: Coordinator {
    
    enum DeepLink {
        
    }
    
    let tabBarViewController = TabBarViewController()
    private let window: UIWindow
    
    // Coordinators
    let reposCoordinator: RepositoriesCoordinator
    let prCoordinator: PRCoordinator
    let issuesCoordinator: IssuesCoordinator
    let profileCoordinator: ProfileCoordinator
    
    init(window: UIWindow) {
        self.window = window
        reposCoordinator = RepositoriesCoordinator()
        prCoordinator = PRCoordinator()
        issuesCoordinator = IssuesCoordinator()
        profileCoordinator = ProfileCoordinator()
        super.init()
    
        addChild(reposCoordinator)
        addChild(prCoordinator)
        addChild(issuesCoordinator)
        addChild(profileCoordinator)
        
        tabBarViewController.viewControllers = [
            reposCoordinator.rootVC,
            prCoordinator.rootVC,
            issuesCoordinator.rootVC,
            profileCoordinator.rootVC
        ]
        
        tabBarViewController.onTabSelect = { [weak self] tab in
            switch tab {
            case .repositories: self?.runReposFlow()
            case .pullRequests: self?.runPRFlow()
            case .issues: self?.runIssueFlow()
            case .profile: self?.runProfileFlow()
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
        profileCoordinator.start()
    }
    
    private func runReposFlow(_ deepLink: RepositoriesCoordinator.DeepLink? = nil) {
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
    
    private func runProfileFlow(_ deepLink: ProfileCoordinator.DeepLink? = nil) {
        if tabBarViewController.selectedIndex != TabBarView.Tab.profile.rawValue {
            tabBarViewController.selectedIndex = TabBarView.Tab.profile.rawValue
        } else {
            issuesCoordinator.handleSecondTabTap()
        }
    }
}
