import UIKit

final class PullRequestsCollectionVC: UIViewController {
    
//    var items: [PullRequest] = [] {
//        didSet { collection.items = items }
//    }
    
    private let router: RepositoriesRouter
    private let mode: Mode
//    private let collection = GitHubViewerCollection()
    
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
        switch mode {
        case .created:
            view.backgroundColor = .green
        case .assigned:
            view.backgroundColor = .yellow
        case .mentioned:
            view.backgroundColor = .cyan
        case .reviewRequests:
            view.backgroundColor = .blue
        }
    }
}

//MARK: - Mode
extension PullRequestsCollectionVC {
    enum Mode {
        case created
        case assigned
        case mentioned
        case reviewRequests
        
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
