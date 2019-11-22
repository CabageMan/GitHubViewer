import UIKit

final class ReposVC: UIViewController {
    
    //MARK: - Life Cycle
    init() {
        super.init(nibName: nil, bundle: nil)
        title = String.Repos.title
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getRepositories()
    }
    
    private func setupUI() {
        view.backgroundColor = .mainBackground
        
        let menuButtonItem = UIBarButtonItem.rightButton(image: #imageLiteral(resourceName: "menu20")) { [weak self] in self?.menuTapped() }
        navigationItem.setRightBarButton(menuButtonItem, animated: false)
    }
    
    //MARK: - Actions
    private func menuTapped() {
        Global.showComingSoon()
    }
    
    private func getRepositories() {
        let order = RepositoryOrder(field: .createdAt, direction: .desc)
        GitHubViewerApollo.shared.client.fetch(query: GetOwnUserQuery(order: order, numberOfRepositories: 20)) { result in
            log("Result: \(result)")
        }
    }
}
