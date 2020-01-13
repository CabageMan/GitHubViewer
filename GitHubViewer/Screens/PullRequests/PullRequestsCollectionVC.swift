import UIKit

final class PullRequestsCollectionVC: UIViewController {
    
    let collection = GitHubViewerCollection<PullRequestsCollectionCell>(mode: .pullRequests)
    var items: [PullRequest] = [] {
        didSet { collection.items = items }
    }
    let mode: PageMode
    
    private let router: GithubViewerRouter
    
    var collectionWillAppear: () -> Void = { }
    var onCollectionHeaderSelectChanged: () -> Void = { }
    var getNextPullRequests: () -> Void = { }
    
    //MARK: - Life Cycle
    init(router: GithubViewerRouter, mode: PageMode) {
        self.router = router
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
        title = mode.title
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionWillAppear()
    }
    
    private func setupUI() {
        collection.collectionView.add(to: view).do {
            $0.edgesToSuperview()
            $0.keyboardDismissMode = .onDrag
        }
        collection.onCellTap = { [weak self] request in
            self?.router.showPullRequestDetails(pullRequest: request)
        }
        collection.getNextData = { [weak self] in
            self?.getNextPullRequests()
        }
        collection.onHeaderSelectorChanged = onCollectionHeaderSelectChanged
    }
}
