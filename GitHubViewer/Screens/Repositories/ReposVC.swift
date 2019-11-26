import UIKit

final class ReposVC: UIViewController {
    
    private let collection = RepositoriesCollection()
    
    private let viewModel = ReposVM()
    private let keyBoardObserver = KeyboardObserver()
    
    var onReposCellTap: (Repository) -> Void = { _ in }
    
    //MARK: - Life Cycle
    init() {
        super.init(nibName: nil, bundle: nil)
        title = String.Repos.title
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        viewModel.getOwnUser()
    }
    
    private func setupUI() {
        view.backgroundColor = .mainBackground
        
        let menuButtonItem = UIBarButtonItem.menu { [weak self] in self?.onMenuButtonTap() }
        navigationItem.setRightBarButton(menuButtonItem, animated: false)
        
        collection.collectionView.add(to: view).do {
            $0.edgesToSuperview()
            $0.keyboardDismissMode = .onDrag
        }
        collection.onCellTap = { [weak self] repo in
            self?.collection.headerView?.searchField.textField.resignFirstResponder()
            self?.onReposCellTap(repo)
        }
    }
    
    private func setupViewModel() {
        viewModel.ownerHasBeenFetched = { [weak self] repositories in
            self?.collection.items = repositories
        }
    }
    
    //MARK: - Actions
    private func onMenuButtonTap() {
        Global.showComingSoon()
    }
}
