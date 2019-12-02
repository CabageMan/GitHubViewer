import UIKit
import SafariServices

final class RepositoryDetailsVC: UIViewController {
    
    var ownerLogin: String
    var repository: Repository
    private let viewModel = RepositoryDetailsVM()
    
    private let table = RepositoryDetailsTableView()
//    private var container = ScrollableStack()
    
    //MARK: - Life Cycle
    init(ownerLogin: String, repository: Repository) {
        self.ownerLogin = ownerLogin
        self.repository = repository
        super.init(nibName: nil, bundle: nil)
        title = repository.resourcePath
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
        
        table.tableView.add(to: view).do {
            $0.edgesToSuperview()
        }
    }
    
    private func setupViewModel() {
        viewModel.repositoryOwnerLogin = ownerLogin
        viewModel.repository = repository
        viewModel.repositoryHasBeenFetched = { [weak self] in self?.setupDetails() }
    }
    
    //MARK: - Actions
    private func setupDetails() {
//        let infoItems = viewModel.createInfoContent()
//        let linkItems = viewModel.createLinksContent() { [weak self] url in
//            self?.callMenuOnTappedLink(url)
//        }
//        let listItems = viewModel.createListContent()
//
//        DetailsCardsView(
//            title: String.Repos.repositoryDetails,
//            infoItems: infoItems,
//            linkItems: linkItems,
//            listItems: listItems
//        ).add(toStackContainer: container).do {
//            $0.backgroundColor = .clear
//            $0.dropShadow()
//        }
        let sections = viewModel.createSections()
        table.sections = sections
//        log("Sections: \(sections)")
    }
    
    private func onBackButtonTap() {
        dismiss()
    }
    
    private func onMenuButtonTap() {
        Global.showComingSoon()
    }
}

//MARK: - Links Handling
extension RepositoryDetailsVC {
    private func callMenuOnTappedLink(_ link: String) {
        let menuController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet).then {
            let openLinkAction = UIAlertAction(
                title: String.General.openLink,
                style: .default,
                handler: { [weak self] _ in self?.openLink(link) }
            )
            let copyLinkAction = UIAlertAction(
                title: String.General.copyLink,
                style: .default,
                handler: { [weak self] _ in self?.copyLink(link) }
            )
            
            $0.addAction(.cancel())
            $0.addAction(openLinkAction)
            $0.addAction(copyLinkAction)
            
            $0.view.tintColor = .textDarkBlue
        }
        present(menuController, animated: true)
        #warning("Temporary solution for bug with action sheet")
        menuController.pruneNegativeWidthConstraints()
    }
    
    private func openLink(_ link: String) {
        guard let url = URL(string: link) else {
            // Error Handling
            return
        }
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        let safariVC = SFSafariViewController(url: url, configuration: config)
        present(safariVC, animated: true)
    }
    
    private func copyLink(_ link: String) {
        let infoAlert = InfoModalAlertView(title: String.General.linkCopied, details: String.Fake.useLinkAnywhere)
        let url = URL(string: link)
        UIPasteboard.general.url = url
        DispatchQueue.main.async {
            infoAlert.presentAlert()
        }
    }
}
