import UIKit

final class PullRequestsVC: UIViewController {
    
    private let router: GithubViewerRouter
    private let scrollPageController: GitHabViewerPagingController
    private let viewModel = PullRequestsVM()
    
    //MARK: - Life Cycle
    init(router: GithubViewerRouter, currentPage: PageMode) {
        self.router = router
        self.scrollPageController = GitHabViewerPagingController(
            viewControllers: PageMode.all.map { PullRequestsCollectionVC(router: router, mode: $0) },
            currentPage: currentPage.rawValue
        )
        super.init(nibName: nil, bundle: nil)
        title = String.Pr.title
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        Spinner.start()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDataToCollection(at: scrollPageController.currentPageIndex)
    }
    
    //MARK: - Actions
    private func setupUI() {
        view.backgroundColor = .mainBackground
        
        let menuButtonItem = UIBarButtonItem.menu { [weak self] in self?.router.showMenu() }
        navigationItem.setRightBarButton(menuButtonItem, animated: false)
        
        add(scrollPageController.pagingController)
        scrollPageController.pagingController.view.edgesToSuperview()
        scrollPageController.didScroll = { [weak self] index in
            self?.loadDataToCollection(at: index)
        }
        scrollPageController.viewControllers.enumerated().forEach { index, controller in
            let vc = controller as! PullRequestsCollectionVC
            vc.onCollectionHeaderSelectChanged = { [weak self] in
                self?.setPullRequestsCollection(at: index)
            }
            vc.getNextPullRequests = { [weak self, weak vc] in
                vc?.collection.nextDataIsLoading = true
                self?.viewModel.getOwnPullRequests()
            }
        }
    }
    
    private func setupViewModel() {
        viewModel.pullRequestsHaveBeenFetched = { [weak self] in
            guard let self = self else { return }
            Spinner.stop()
            self.setPullRequestsCollection(at: self.scrollPageController.currentPageIndex)
        }
    }
    
    private func loadDataToCollection(at index: Int) {
        guard let vc = scrollPageController.viewControllers[index] as? PullRequestsCollectionVC else {
            setPullRequestsCollection(at: index)
            return
        }
        vc.collection.nextDataIsLoading = true
        viewModel.resetDataSource()
        viewModel.getOwnPullRequests()
        setPullRequestsCollection(at: index)
    }
    
    private func setPullRequestsCollection(at index: Int) {
        guard let vc = self.scrollPageController.viewControllers[index] as? PullRequestsCollectionVC,
              let page = PageMode(rawValue: index),
              let selector = vc.collection.selectorHeader?.selector
        else { return }
        vc.collection.nextDataIsLoading = false
        vc.items = viewModel.getPullRequests(for: page, selector: selector)
    }
}

//MARK: - Theme
extension PullRequestsVC {
    enum Theme {
        // Offsets
        static let emptyViewOffset: CGFloat = 70.0
    }
}
