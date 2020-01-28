import UIKit

final class IssuesVC: UIViewController {
    
    private let router: GithubViewerRouter
    private let fixedPageController: GitHabViewerPagingController
    private let viewModel = IssuesVM()
    
    //MARK: - Life Cycle
    init(router: GithubViewerRouter, currentPage: PageMode) {
        self.router = router
        self.fixedPageController = GitHabViewerPagingController(
            viewControllers: PageMode.issueMode.map { IssueCollectionVC(router: router, mode: $0) },
            currentPage: currentPage.rawValue
        )
        super.init(nibName: nil, bundle: nil)
        title = String.Issues.title
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
        
        add(fixedPageController.pagingController)
        fixedPageController.pagingController.view.edgesToSuperview()
        fixedPageController.didScroll = { [weak self] index in
            self?.setIssuesCollection(at: index)
        }
        fixedPageController.viewControllers.enumerated().forEach { index, controller in
            let vc = controller as! IssueCollectionVC
            vc.collectionWillAppear = { [weak self, weak vc] in
                #warning("Fix updating on swiping first or last VC to the edges")
                vc?.collection.nextDataIsLoading = true
                self?.viewModel.resetDataSource()
                self?.viewModel.getOwnIssues()
            }
            vc.onCollectionheaderSelectChanged = { [weak self] in
                self?.setIssuesCollection(at: index)
            }
            vc.getNextIssues = { [weak self, weak vc] in
                vc?.collection.nextDataIsLoading = true
                self?.viewModel.getOwnIssues()
            }
        }
    }
    
    private func setupViewModel() {
        viewModel.issuesHaveBeenFetched = { [weak self] in
            guard let self = self else { return }
            Spinner.stop()
            self.setIssuesCollection(at: self.fixedPageController.currentPageIndex)
        }
    }
    
    private func setIssuesCollection(at index: Int) {
        guard let vc = self.fixedPageController.viewControllers[index] as? IssueCollectionVC,
              let page = PageMode(rawValue: index),
              let selector = vc.collection.selectorHeader?.selector
        else { return }
        vc.collection.nextDataIsLoading = false
        vc.items = viewModel.getIssues(for: page, selector: selector)
    }
}

//MARK: -Theme
extension IssuesVC {
    enum Theme {
        // Offsets
        static let emptyViewOffset: CGFloat = 70.0
    }
}
