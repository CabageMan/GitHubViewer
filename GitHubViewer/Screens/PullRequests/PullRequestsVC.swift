import UIKit

final class PullRequestsVC: UIViewController {
    
    private let router: RepositoriesRouter
    private let fixedPageController: GitHabViewerPagingController
    private let viewModel = PullRequestsVM()
    
    //MARK: - Life Cycle
    init(router: RepositoriesRouter, pagingController: GitHabViewerPagingController) {
        self.router = router
        self.fixedPageController = pagingController
        super.init(nibName: nil, bundle: nil)
        title = String.Pr.title
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        viewModel.getOwnPullRequests()
        Spinner.start()
    }
    
    private func setupUI() {
        view.backgroundColor = .mainBackground
        
        let menuButtonItem = UIBarButtonItem.menu { [weak self] in self?.router.showMenu() }
        navigationItem.setRightBarButton(menuButtonItem, animated: false)
        
        add(fixedPageController.pagingController)
        fixedPageController.pagingController.view.edgesToSuperview()
        fixedPageController.didScroll = { index in
            
        }
    }
    
    private func setupViewModel() {
        viewModel.pullRequestsHaveBeenFetched = { [weak self] pullrequests in
            Spinner.stop()
            self?.fixedPageController.viewControllers.forEach { controller in
                let vc = controller as! PullRequestsCollectionVC
                vc.items = pullrequests
            }
        }
    }
}

//MARK: - Theme
extension PullRequestsVC {
    enum Theme {
        // Offsets
        static let emptyViewOffset: CGFloat = 70.0
    }
}
