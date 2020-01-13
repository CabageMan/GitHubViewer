import UIKit

final class IssueCollectionVC: UIViewController {
    
    let collection = GitHubViewerCollection<IssueCollectionCell>(mode: .issues)
    var items: [Issue] = [] {
        didSet { collection.items = items }
    }
    let mode: PageMode
    
    private let router: GithubViewerRouter
    
    var collectionWillAppear: () -> Void = { }
    var onCollectionheaderSelectChanged: () -> Void = { }
    var getNextIssues: () -> Void = { }
    
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
        collection.onCellTap = { [weak self] issue in
            self?.router.showIssuesDetails(issue: issue)
        }
        collection.getNextData = { [weak self] in
            self?.getNextIssues()
        }
        collection.onHeaderSelectorChanged = onCollectionheaderSelectChanged
    }
}
