import UIKit

final class SideMenuController: UIViewController {
    
    private let viewModel: SideMenuVM
    private var tabBarViewController: TabBarViewController? {
        guard let coordinator: TabBarCoordinator = viewModel.router.currentCoordinator?.findParent() else { return nil }
        return coordinator.tabBarViewController
    }
    
    //MARK: - Life Cycle
    init(router: RepositoriesRouter) {
        viewModel = SideMenuVM(router: router)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarViewController?.hideTabBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tabBarViewController?.showTabBar()
    }
    
    private func setupUI() {
        view.backgroundColor = .cyan
        viewModel.menuTable.tableView.add(to: view).do {
            $0.edgesToSuperview()
        }
    }
}

//TODO:
// Fix Hiding Tab bar on calling from repositories detailss. Maybe need to remove repository details
// coordinator and call this screen from repositories coordinator, or from the router.
// Check on leaks
// Create setting config
// Push settings from bottom
