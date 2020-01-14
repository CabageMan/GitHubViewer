import UIKit

final class IssueDetailsVC: UIViewController {
    
    private let router: GithubViewerRouter
    
    private let issue: Issue
    private let issueNameLabel = UILabel()
//    private let issueStateView: PullRequestStateView
    private let descriptionLabel = UILabel()
//    private let commentsCollection = GitHubViewerCollection
    
    //MARK: - Life Cycle
    init(router: GithubViewerRouter, issue: Issue) {
        self.router = router
        self.issue = issue
        super.init(nibName: nil, bundle: nil)
        title = issue.repository.resourcePath
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        log("Comments: \(issue.comments)")
    }
    
    
    //MARK: - Actions
    private func setupUI() {
        view.backgroundColor = .mainBackground
        
        let backButton = UIBarButtonItem.back { [weak self] in self?.dismiss() }
        navigationItem.setLeftBarButton(backButton, animated: false)
        
        let menuButtonItem = UIBarButtonItem.menu { [weak self] in self?.router.showMenu() }
        navigationItem.setRightBarButton(menuButtonItem, animated: false)
    }
}
