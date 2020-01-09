import UIKit

final class PullRequestsVC: UIViewController {
    
    typealias Page = PullRequestsCollectionVC.Mode
    
    private let router: RepositoriesRouter
    private let fixedPageController: GitHabViewerPagingController
    private let viewModel = PullRequestsVM()
    
    //MARK: - Life Cycle
    init(router: RepositoriesRouter, currentPage: Page) {
        self.router = router
        self.fixedPageController = GitHabViewerPagingController(
            viewControllers: Page.all.map { PullRequestsCollectionVC(router: router, mode: $0) },
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
        viewModel.getOwnPullRequests()
        Spinner.start()
    }
    
    //MARK: - Actions
    private func setupUI() {
        view.backgroundColor = .mainBackground
        
        let menuButtonItem = UIBarButtonItem.menu { [weak self] in self?.router.showMenu() }
        navigationItem.setRightBarButton(menuButtonItem, animated: false)
        
        add(fixedPageController.pagingController)
        fixedPageController.pagingController.view.edgesToSuperview()
        fixedPageController.didScroll = { [weak self] index in
            self?.setPullRequestsCollection(at: index)
        }
        fixedPageController.viewControllers.enumerated().forEach { index, controller in
            let vc = controller as! PullRequestsCollectionVC
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
            self.setPullRequestsCollection(at: self.fixedPageController.currentPageIndex)
        }
    }
    
    private func setPullRequestsCollection(at index: Int) {
        guard let vc = self.fixedPageController.viewControllers[index] as? PullRequestsCollectionVC,
              let page = Page(rawValue: index),
              let selector = vc.collection.pullRequestHeader?.selector
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
