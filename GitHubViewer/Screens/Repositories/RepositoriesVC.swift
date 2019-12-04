import UIKit

final class RepositoriesVC: UIViewController {
    
    private let collection = RepositoriesCollection()
    private let searchController = UISearchController(searchResultsController: nil)
    private let viewModel = RepositoriesVM()
    private let keyBoardObserver = KeyboardObserver()
    
    private var allRepositories: [Repository] = []
    private var filteredRepositories: [Repository] = []
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.searchController = nil
    }
    
    private func setupUI() {
        view.backgroundColor = .mainBackground
        #warning("Solve problem with navigation bar appearance and `extendedLayoutIncludesOpaqueBars = true`")
//        extendedLayoutIncludesOpaqueBars = true
        
        let menuButtonItem = UIBarButtonItem.menu { [weak self] in self?.onMenuButtonTap() }
        navigationItem.setRightBarButton(menuButtonItem, animated: false)
        
        searchController.do {
            $0.searchResultsUpdater = self
            $0.searchBar.delegate = self
            $0.obscuresBackgroundDuringPresentation = false
            $0.searchBar.placeholder = String.Repos.findRepository
            $0.searchBar.searchTextField.textColor = .red
            $0.searchBar.barStyle = .black
            let image = #imageLiteral(resourceName: "searchLeft20")
            $0.searchBar.setImage(image.withRenderingMode(.alwaysTemplate), for: .search, state: .normal)
            $0.searchBar.tintColor = .white
            $0.searchBar.barTintColor = .white
        }
        definesPresentationContext = true
        
        collection.collectionView.add(to: view).do {
            $0.edgesToSuperview()
            $0.keyboardDismissMode = .onDrag
        }
        collection.onCellTap = { [weak self] repo in
            self?.onReposCellTap(repo)
        }
    }
    
    private func setupViewModel() {
        viewModel.ownerHasBeenFetched = { [weak self] repositories in
            self?.collection.items = repositories
            self?.allRepositories = repositories
        }
    }
    
    //MARK: - Actions
    private func onMenuButtonTap() {
        Global.showComingSoon()
    }
}

//MARK: - Search Controller Functionality
extension RepositoriesVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            filteredRepositories = []
            collection.items = allRepositories
            return
        }
        filterRepositoriesForSearchText(searchText)
    }
    
    private func filterRepositoriesForSearchText(_ searchText: String) {
        filteredRepositories = allRepositories.filter { (repository: Repository) -> Bool in
            return repository.name.lowercased().contains(searchText.lowercased())
        }
        collection.items = filteredRepositories
    }
}

extension RepositoriesVC: UISearchBarDelegate {
    
}
