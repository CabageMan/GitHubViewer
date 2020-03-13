import UIKit

final class ProfileVC: UIViewController {
    
    private let router: GithubViewerRouter
    private let viewModel: ProfileVM
    private let profileContainer = ScrollableStack(axis: .vertical, spacing: Theme.profileItemsSpace, distribution: .fill)
    private let userCard = ProfileUserCard()
    private let pinnedCard = PinnedItemsCard()
    private let chartCard = ProfileChartCard()
    
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
        let currentYear = Calendar.current.component(.year, from: Date())
        let currentYearBounds = currentYear.getBoundsOfYear()
        viewModel.getContributionsHistory(fromDate: currentYearBounds.start, toDate: currentYearBounds.end)
    }
    
    //MARK: - Actions
    private func setupUI() {
        view.backgroundColor = .mainBackground
        
        let menuButtonItem = UIBarButtonItem.menu { [weak self] in self?.router.showMenu() }
        navigationItem.setRightBarButton(menuButtonItem, animated: false)
        
        userCard.do {
            $0.width(UIScreen.main.bounds.width)
            $0.height(UIScreen.main.bounds.width + ProfileUserCard.Theme.avatarHeightOffset)
            if let user = Global.apiClient.ownUser {
                $0.configure(with: user)
            }
        }
        
        pinnedCard.do {
            $0.width(UIScreen.main.bounds.width)
            $0.itemDidSelect = { item in
                switch item {
                case .repository(let repository):
                    Global.showCustomMessage(message: "You selected repository:\n\(repository.name)")
                case .gist(let gist):
                    guard let gistName = gist.description else { return }
                    Global.showCustomMessage(message: "You selected gist:\n\(gistName)")
                }
            }
        }
        
        chartCard.do {
            $0.width(UIScreen.main.bounds.width)
            $0.height(UIScreen.main.bounds.width + ProfileUserCard.Theme.avatarHeightOffset)
            $0.chartBarSelected = { [weak self] barIndex in
                guard let self = self else { return }
                Global.showCustomMessage(message: "You selected day:\n\(self.viewModel.getContributionsDays()[barIndex].date)")
            }
            $0.yearSelected = { [weak self] selectedYear in
                guard let self = self else { return }
                Spinner.start()
                let selectedYearBounds = selectedYear.getBoundsOfYear()
                self.viewModel.getContributionsHistory(fromDate: selectedYearBounds.start, toDate: selectedYearBounds.end)
            }
        }
        
        profileContainer.add(to: view).do {
            $0.edgesToSuperview(excluding: .bottom)
            $0.bottomToSuperview(offset: -Theme.containerBottomOffset)
            $0.scrollView.alwaysBounceHorizontal = false
            $0.stackView.addArrangedSubviews([userCard, pinnedCard, chartCard])
        }
    }
    
    private func setupViewmodel() {
        viewModel.pinnedItemsHaveBeenFetched = { [weak self] in
            Spinner.stop()
            guard let self = self else { return }
            self.pinnedCard.pinnedItems = self.viewModel.pinnedItems
        }
        viewModel.contributionsHaveBeenFetched = { [weak self] in
            Spinner.stop()
            guard let self = self, let contributionCollection = self.viewModel.contributionsCollection else { return }
            
            let startedAt = Calendar.current.dateComponents([.year], from: contributionCollection.startedAt).year
            let years = contributionCollection.contributionsYears
            
            self.chartCard.updateChart(days: self.viewModel.getContributionsDays())
            self.chartCard.updateSelectorView(years: years, startedAt: startedAt)
        }
    }
}

//MARK: - Theme
extension ProfileVC {
    enum Theme {
        // Offsets
        static let emptyViewOffset: CGFloat = 70.0
        static let containerBottomOffset: CGFloat = 100.0
        static let profileItemsSpace: CGFloat = 13.0
    }
}
