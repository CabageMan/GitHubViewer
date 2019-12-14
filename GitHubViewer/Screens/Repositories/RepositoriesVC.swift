import UIKit

final class RepositoriesVC: UIViewController {
    
    private let router: RepositoriesRouter
    
    private let collection = RepositoriesCollection()
    private let searchController = UISearchController(searchResultsController: nil)
    private let viewModel = RepositoriesVM()
    private let keyBoardObserver = KeyboardObserver()
    
    private var allRepositories: [Repository] = []
    private var filteredRepositories: [Repository] = []
    
    var onReposCellTap: (Repository) -> Void = { _ in }
    
    //MARK: - Life Cycle
    init(router: RepositoriesRouter) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
        title = String.Repos.title
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.isActive = false
        #warning("Change updating logic to update all fetched repositores")
        collection.items = []
        allRepositories = []
        viewModel.resetPaginationOptions()
        
        viewModel.getOwnUser()
        Spinner.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupUI() {
        view.backgroundColor = .mainBackground
        #warning("Solve problem with navigation bar appearance and `extendedLayoutIncludesOpaqueBars = true`")
//        extendedLayoutIncludesOpaqueBars = true
        
        let menuButtonItem = UIBarButtonItem.menu { [weak self] in self?.router.showMenu() }
        navigationItem.do {
            $0.setRightBarButton(menuButtonItem, animated: false)
            $0.searchController = searchController
        }
        
        searchController.do {
            $0.searchResultsUpdater = self
            $0.searchBar.delegate = self
            $0.obscuresBackgroundDuringPresentation = false
            $0.searchBar.placeholder = String.Repos.findRepository
            $0.searchBar.searchTextField.textColor = .white
            $0.searchBar.searchTextField.tintColor = .white
            
            let container = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 30.0, height: 30.0))
            let searchIcon = #imageLiteral(resourceName: "searchLeft20")
            UIImageView(image: searchIcon.withRenderingMode(.alwaysTemplate)).add(to: container).do {
                $0.frame = CGRect(x: 5.0, y: 5.0, width: 20.0, height: 20.0)
            }
            $0.searchBar.searchTextField.leftView = container
            $0.searchBar.searchTextField.leftViewMode = .always
            
            definesPresentationContext = true
        }
        
        collection.collectionView.add(to: view).do {
            $0.edgesToSuperview()
            $0.keyboardDismissMode = .onDrag
        }
        collection.onCellTap = { [weak self] repo in
            self?.onReposCellTap(repo)
        }
        collection.getNextData = { [weak self] in
            self?.collection.nextDataIsLoading = true
            self?.viewModel.getOwnRepositories()
        }
    }
    
    private func setupViewModel() {
        viewModel.repositoriesHaveBeenFetched = { [weak self] repositories in
            if !repositories.isEmpty {
                self?.collection.items += repositories
                self?.allRepositories += repositories
            }
            self?.collection.nextDataIsLoading = false
            Spinner.stop()
        }
        viewModel.ownerHasBeenFetched = { [weak self] in
            self?.viewModel.getOwnRepositories()
        }
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
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let owner = Global.apiClient.ownUser, let repositoryName = searchBar.text else { return }
        viewModel.findRepository(
            ownerLogin: owner.login,
            repositoryName: repositoryName,
            completion: { [weak self] repository in
                log("Fetched Repository: \(repository)")
                self?.filteredRepositories = [repository]
                self?.collection.items = [repository]
            }
        )
    }
}
