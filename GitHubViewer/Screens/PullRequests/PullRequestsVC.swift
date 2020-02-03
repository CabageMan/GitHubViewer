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
    
    //MARK: - Actions
    private func setupUI() {
        view.backgroundColor = .mainBackground
        
        let menuButtonItem = UIBarButtonItem.menu { [weak self] in self?.router.showMenu() }
        navigationItem.setRightBarButton(menuButtonItem, animated: false)
        
        add(scrollPageController.pagingController)
        scrollPageController.pagingController.view.edgesToSuperview()
        scrollPageController.didScroll = { [weak self] index in
            self?.setPullRequestsCollection(at: index)
        }
        scrollPageController.viewControllers.enumerated().forEach { index, controller in
            let vc = controller as! PullRequestsCollectionVC
            vc.collectionWillAppear = { [weak self] in
                self?.viewModel.resetDataSource()
                self?.viewModel.getOwnPullRequests()
            }
            vc.onCollectionHeaderSelectChanged = { [weak self] in
                self?.setPullRequestsCollection(at: index)
            }
            vc.getNextPullRequests = { [weak self, weak vc] in
                self?.viewModel.getOwnPullRequests()
                vc?.collection.nextDataIsLoading = true
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
