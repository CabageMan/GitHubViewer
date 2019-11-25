import UIKit

final class ReposVC: UIViewController {
    
    private let collection = RepositoriesCollection()
    
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
        
        collection.collectionView.add(to: view).do {
            $0.edgesToSuperview()
        }
    }
    
    //MARK: - Actions
    private func menuTapped() {
        Global.showComingSoon()
    }
    
    private func getRepositories() {
        let order = RepositoryOrder(field: .createdAt, direction: .desc)
        GitHubViewerApollo.shared.client.fetch(query: OwnUserQuery(order: order, numberOfRepositories: 30)) { [weak self] response in
            switch response {
            case .success(let result):
                guard let viewer = result.data?.viewer else { return }
                Global.apiClient.ownUser = User(user: viewer)
                if let repositories = Global.apiClient.ownUser?.repositories {
                    self?.collection.items = repositories
                }
            case .failure(let error):
                log("Error: \(error.localizedDescription)")
            }
        }
    }
}
