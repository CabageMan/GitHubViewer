import UIKit

final class ProfileVC: UIViewController {
    
    private let router: GithubViewerRouter
    private let viewModel: ProfileVM
    
    private let collection = GitHubViewerCollection<ProfileCollectionCell>(mode: .profile)
    private var profileItems: [ProfileItem] = (Theme.userItemIndex...Theme.chartItemIndex).map { _ in ProfileItem.empty } {
        didSet { collection.items = profileItems }
    }
    #warning("Update collection only when we have any data")
//    private let chartView = BarChartView()
//    private var yearSelector = YearSelector()
    
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
        
        collection.collectionView.add(to: view).do {
            $0.edgesToSuperview()
        }
        
        if let user = Global.apiClient.ownUser {
            let userItem = ProfileItem.user(user)
            profileItems[Theme.userItemIndex] = userItem
        }
        
        
//        chartView.add(to: view).do {
//            $0.centerInSuperview()
//            $0.width(BarChartView.Theme.chartViewFrame.width)
//            $0.height(BarChartView.Theme.chartViewFrame.height)
//            $0.barHasTouched = { [weak self] barIndex in
//                guard let self = self, let index = barIndex else { return }
//                let day = self.viewModel.getContributionsDays()[index]
//                log("Selected day date: \(day.date)")
//            }
//        }
//
//        yearSelector.selectorContainer.add(to: view).do {
//            $0.centerXToSuperview()
//            $0.width(UIScreen.main.bounds.width - 20.0)
//            $0.topToBottom(of: chartView, offset: Theme.yearSelectorOffset)
//        }
//        yearSelector.yearDidSelect = { [weak self] selectedYear in
//            guard let self = self else { return }
//            Spinner.start()
//            let selectedYearBounds = self.viewModel.getBoundsOfYear(selectedYear)
//            self.viewModel.getContributionsHistory(fromDate: selectedYearBounds.start, toDate: selectedYearBounds.end)
//        }
    }
    
    private func setupViewmodel() {
        viewModel.pinnedItemsHaveBeenFetched = { [weak self] in
            Spinner.stop()
            guard let self = self else { return }
            let pinnedItems = ProfileItem.PinnedItems(repositories: self.viewModel.pinnedRepositories, gists: self.viewModel.pinnedGists)
            self.profileItems[Theme.pinnedItemsIndex] = ProfileItem.pinned(pinnedItems)
        }
        viewModel.contributionsHaveBeenFetched = { [weak self] in
            Spinner.stop()
            guard let self = self, let contributionCollection = self.viewModel.contributionsCollection else { return }
            let startedAt = Calendar.current.dateComponents([.year], from: contributionCollection.startedAt).year
            let years = contributionCollection.contributionsYears
            let days = self.viewModel.getContributionsDays()
            let onBarSelect: (ContributionsCollection.ContributionDay) -> Void = { day in
                log("Selected day date: \(day.date)")
            }
            let onYearSelect: (Int) -> Void = { [weak self] selectedYear in
                guard let self = self else { return }
                Spinner.start()
                let selectedYearBounds = selectedYear.getBoundsOfYear()
                self.viewModel.getContributionsHistory(fromDate: selectedYearBounds.start, toDate: selectedYearBounds.end)
            }
            let contributions = ProfileItem.Contributions(
                contributionsStartedAt: startedAt,
                contributionsYears: years,
                contributionsDays: days,
                onBarSelect: onBarSelect,
                onYearSelect: onYearSelect
            )
            self.profileItems[Theme.chartItemIndex] = ProfileItem.contributions(contributions)
            
//            self.drawChart()
//            self.updateYearSelector()
        }
    }
    
    private func updateProfileItems(with item: ProfileItem, at index: Int) {
        profileItems[index] = item
    }
    
    // To Collection Cell
//    private func drawChart() {
//        let contributionsDays = viewModel.getContributionsDays()
//        chartView.updateDataEntries(with: generateEmptyDataEntries(contributionsDays.count), animated: false)
//        chartView.updateDataEntries(with: generateDataEntries(for: contributionsDays), animated: true)
//    }
//
//    private func updateYearSelector() {
//        guard let contributionsCollection = viewModel.contributionsCollection else { return }
//        let selectedYear = Calendar.current.dateComponents([.year], from: contributionsCollection.startedAt).year
//        yearSelector.update(with: contributionsCollection.contributionsYears, selectedYear: selectedYear)
//    }
//
//    private func generateEmptyDataEntries(_ entryNumber: Int) -> [ChartDataEntry] {
//        return (0..<entryNumber).map { _ in ChartDataEntry(color: .clear, value: 0, textValue: "0", title: "") }
//    }
//
//    private func generateDataEntries(for contributionsDays: [ContributionsCollection.ContributionDay]) -> [ChartDataEntry] {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "d MMM"
//        return contributionsDays.map { day in
//            let color: UIColor = UIColor(hexString: day.color)
//            let textValue: String = "\(day.contributionCount)"
//            let title: String = formatter.string(from: day.date)
//
//            return ChartDataEntry(color: color, value: Float(day.contributionCount), textValue: textValue, title: title)
//        }
//    }
}

//MARK: - Theme
extension ProfileVC {
    enum Theme {
        // Indexes
        static let userItemIndex: Int = 0
        static let pinnedItemsIndex: Int = 1
        static let chartItemIndex: Int = 2
        
        // Offsets
        static let emptyViewOffset: CGFloat = 70.0
//        static let yearSelectorOffset: CGFloat = 13.0
    }
}
