import UIKit
import Parchment

final class PullRequestsVC: UIViewController {
    
    private let router: RepositoriesRouter
    private let fixedPageController: FixedPagingViewController
    private let viewModel = PullRequestsVM()
    
    //MARK: - Life Cycle
    init(router: RepositoriesRouter, pagingController: FixedPagingViewController) {
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
        
        EmptyView.createEmptyPullRequests(offset: -Theme.emptyViewOffset).add(to: view).do {
            $0.edgesToSuperview()
        }
        
        add(fixedPageController)
        fixedPageController.view.do {
            $0.edgesToSuperview()
        }
    }
    
    private func setupViewModel() {
        viewModel.pullRequestsHaveBeenFetched = { pullrequests in
            Spinner.stop()
            pullrequests.forEach {
                log("\n")
                log("Pull Requests:\nName: \($0.id)\nState: \($0.state)\nAuthor: \($0.author)\nAssignees \($0.assignees)")
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
