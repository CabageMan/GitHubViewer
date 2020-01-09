import UIKit

final class IssuesVC: UIViewController {
    
    private let router: RepositoriesRouter
    
    private let viewModel = IssuesVM()
    
    //MARK: - Life Cycle
    init(router: RepositoriesRouter) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
        title = String.Issues.title
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        viewModel.getOwnIssues()
    }
    
    //MARK: - Actions
    private func setupUI() {
        view.backgroundColor = .mainBackground
        
        let menuButtonItem = UIBarButtonItem.menu { [weak self] in self?.router.showMenu() }
        navigationItem.setRightBarButton(menuButtonItem, animated: false)
        
        EmptyView.createEmptyIssues(offset: -Theme.emptyViewOffset).add(to: view).do {
            $0.edgesToSuperview()
        }
    }
    
    private func setupViewModel() {
        viewModel.issuesHaveBeenFetched = {
            Global.showCustomMessage(message: "Issues have been fetched!")
        }
    }
}

//MARK: -Theme
extension IssuesVC {
    enum Theme {
        // Offsets
        static let emptyViewOffset: CGFloat = 70.0
    }
}
