import UIKit

final class RepositoriesVC: UIViewController {
    
    private let collection = RepositoriesCollection()
    private let searchController = UISearchController(searchResultsController: nil)
    private let viewModel = RepositoriesVM()
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
        #warning("Solve problem with navigation bar appearance")
//        extendedLayoutIncludesOpaqueBars = true
        
        let menuButtonItem = UIBarButtonItem.menu { [weak self] in self?.onMenuButtonTap() }
        navigationItem.setRightBarButton(menuButtonItem, animated: false)
        
        searchController.do {
            $0.searchResultsUpdater = self
            $0.obscuresBackgroundDuringPresentation = false
            $0.searchBar.placeholder = String.Repos.findRepository
            $0.searchBar.searchTextField.textColor = .red
            $0.searchBar.barStyle = .black
            let image = #imageLiteral(resourceName: "searchLeft20")
            $0.searchBar.setImage(image.withRenderingMode(.alwaysTemplate), for: .search, state: .normal)
            $0.searchBar.tintColor = .white
            $0.searchBar.barTintColor = .white
        }
        
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

extension RepositoriesVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        log("Text for search: \(searchController.searchBar.text ?? "")")
    }
    
    
}

extension RepositoriesVC: UISearchBarDelegate {
    
}
