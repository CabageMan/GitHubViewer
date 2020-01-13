import UIKit

final class IssueDetailsVC: UIViewController {
    
    private let router: GithubViewerRouter
    
    //MARK: - Life Cycle
    init(router: GithubViewerRouter, issue: Issue) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
        title = issue.title
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
