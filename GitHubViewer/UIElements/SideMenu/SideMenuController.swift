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
        
        let backButton = UIBarButtonItem.back { [weak self] in self?.dismiss() }
        navigationItem.setLeftBarButton(backButton, animated: false)
        
        viewModel.menuTable.tableView.add(to: view).do {
            $0.edgesToSuperview()
        }
    }
}

//TODO:
// Check on leaks
// Create setting config
// Push settings from bottom?
