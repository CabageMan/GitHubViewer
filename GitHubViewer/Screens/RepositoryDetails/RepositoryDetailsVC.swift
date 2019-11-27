import UIKit

final class RepositoryDetailsVC: UIViewController {
    
    var ownerLogin: String
    var repository: Repository
    private let viewModel = RepositoryDetailsVM()
    
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
    }
    
    private func setupViewModel() {
        viewModel.repositoryOwnerLogin = ownerLogin
        viewModel.repository = repository
        viewModel.repositoryHasBeenFetched = { details in log("Repository: \(details)") }
    }
    
    //MARK: - Actions
    private func onBackButtonTap() {
        dismiss()
    }
    
    private func onMenuButtonTap() {
        Global.showComingSoon()
    }
}
