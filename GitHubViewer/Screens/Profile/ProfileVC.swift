import UIKit

final class ProfileVC: UIViewController {
    
    private let router: GithubViewerRouter
    private let viewModel: ProfileVM
    
    //MARK: - Life Cycle
    init(router: GithubViewerRouter) {
        self.router = router
        self.viewModel = ProfileVM()
        super.init(nibName: nil, bundle: nil)
        title = String.Profile.title
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewmodel()
        Spinner.start()
        viewModel.getPinnedItems()
        viewModel.getContributionsHistory()
    }
    
    //MARK: - Actions
    private func setupUI() {
        view.backgroundColor = .mainBackground
        
        let menuButtonItem = UIBarButtonItem.menu { [weak self] in self?.router.showMenu() }
        navigationItem.setRightBarButton(menuButtonItem, animated: false)
        
//        EmptyView.createEmptyProfile(offset: -Theme.emptyViewOffset).add(to: view).do {
//            $0.edgesToSuperview()
//        }
        
        ChartView().add(to: view).do {
            $0.centerInSuperview()
            $0.width(UIScreen.main.bounds.width - 20.0)
            $0.height(UIScreen.main.bounds.height / 2)
        }
    }
    
    private func setupViewmodel() {
        viewModel.pinnedItemsHaveBeenFetched = { [weak self] in
            guard let self = self else { return }
            Spinner.stop()
            log("\nPinned Items:\nRepositories: \(self.viewModel.pinnedRepositories)\nGists: \(self.viewModel.pinnedGists)")
        }
        viewModel.contributionsHaveBeenFetched = { [weak self] in
            guard let self = self else { return }
            Spinner.stop()
            guard let contributions = self.viewModel.contributionsCollection, contributions.hasAnyContributions else { return }
            
            contributions.calendar.weeks.forEach {
                log("\nNew week")
                $0.days.forEach {
                    log("Full day name: \($0.weekday.fullName)")
                }
            }
        }
    }
}

//MARK: - Theme
extension ProfileVC {
    enum Theme {
        // Offsets
        static let emptyViewOffset: CGFloat = 70.0
    }
}
