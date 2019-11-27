import UIKit

final class RepositoryDetailsVC: UIViewController {
    
    var ownerLogin: String
    var repository: Repository
    private let viewModel = RepositoryDetailsVM()
    
    private var container = ScrollableStack()
    
    //MARK: - Life Cycle
    init(ownerLogin: String, repository: Repository) {
        self.ownerLogin = ownerLogin
        self.repository = repository
        super.init(nibName: nil, bundle: nil)
        title = repository.name
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        viewModel.getRepositoryInfo()
    }
    
    private func setupUI() {
        view.backgroundColor = .mainBackground
        
        let backButton = UIBarButtonItem.back { [weak self] in self?.onBackButtonTap() }
        navigationItem.setLeftBarButton(backButton, animated: false)
        
        let menuButtonItem = UIBarButtonItem.menu { [weak self] in self?.onMenuButtonTap() }
        navigationItem.setRightBarButton(menuButtonItem, animated: false)
        
        container.add(to: view).do {
            $0.edgesToSuperview()
        }
    }
    
    private func setupViewModel() {
        viewModel.repositoryOwnerLogin = ownerLogin
        viewModel.repository = repository
        viewModel.repositoryHasBeenFetched = { [weak self] details in self?.setupDetails(details) }
    }
    
    //MARK: - Actions
    private func setupDetails(_ details: RepositoryDetails) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm"
        var createdAt = ""
        var updatedAt = ""
        var pushedAt = ""
        if let date = details.repository.createdAt {
            createdAt = formatter.string(from: date)
        }
        if let date = details.pushedAt {
            pushedAt = formatter.string(from: date)
        }
        if let date = details.updatedAt {
            updatedAt = formatter.string(from: date)
        }
        
        let infoItems = [
            DetailsCardView.InfoItem(title: String.Repos.createdAt, details: createdAt),
            DetailsCardView.InfoItem(title: String.Repos.updatedAt, details: updatedAt),
            DetailsCardView.InfoItem(title: String.Repos.pushedAt, details: pushedAt),
            DetailsCardView.InfoItem(title: String.Repos.descriprion, details: details.repository.description ?? "")
        ]
        
        DetailsCardView(title: String.Repos.repositoryDetails, infoItems: infoItems).add(toStackContainer: container)
    }
    
    private func onBackButtonTap() {
        dismiss()
    }
    
    private func onMenuButtonTap() {
        Global.showComingSoon()
    }
}
