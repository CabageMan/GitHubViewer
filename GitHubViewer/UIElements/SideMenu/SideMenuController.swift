import UIKit

final class SideMenuController: UIViewController {
    
    let viewModel: SideMenuVM
    
    //MARK: - Life Cycle
    init() {
        //TODO: Add router and menu type to init, throw it to view model
        viewModel = SideMenuVM()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .cyan
        viewModel.menuTable.tableView.add(to: view).do {
            $0.edgesToSuperview()
        }
    }
}

//TODO:
// Hide Tab bar on calling
// Check on leaks
// Create setting config
// Push settings from bottom
