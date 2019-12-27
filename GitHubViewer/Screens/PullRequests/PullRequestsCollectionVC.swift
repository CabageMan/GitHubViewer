import UIKit

final class PullRequestsCollectionVC: UIViewController {
    
    var items: [PullRequest] = [] {
        didSet { collection.items = items }
    }
    let mode: Mode
    
    private let router: RepositoriesRouter
    private let collection = GitHubViewerCollection<PullRequestsCollectionCell>(mode: .pullRequests)
    
    //MARK: - Life Cycle
    init(router: RepositoriesRouter, mode: Mode) {
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
    
    private func setupUI() {
        collection.collectionView.add(to: view).do {
            $0.edgesToSuperview()
            $0.keyboardDismissMode = .onDrag
        }
        collection.onCellTap = { request in
            Global.showCustomMessage(message: "Soon we can go to \(request.headRefName)")
        }
        collection.getNextData = {
            Global.showCustomMessage(message: "We need to load more data")
        }
    }
}

//MARK: - Mode
extension PullRequestsCollectionVC {
    enum Mode: Int {
        case created = 0
        case assigned
        case mentioned
        case reviewRequests
        
        static var all: [Mode] {
            return [.created, .assigned, .mentioned, .reviewRequests]
        }
        
        var title: String {
            switch self {
            case .created: return String.Pr.created
            case .assigned: return String.Pr.assigned
            case .mentioned: return String.Pr.mentioned
            case .reviewRequests: return String.Pr.reviewRequests
            }
        }
    }
}

//MARK: - Theme
extension PullRequestsCollectionVC {
    enum Theme {
    
    }
}
