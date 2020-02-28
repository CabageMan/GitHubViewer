import UIKit

final class ProfileVC: UIViewController {
    
    private let router: GithubViewerRouter
    private let viewModel: ProfileVM
    
    private let chartView = BarChartView()
    
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
        
        chartView.add(to: view).do {
            $0.centerInSuperview()
            $0.width(UIScreen.main.bounds.width - 20.0)
            $0.height(UIScreen.main.bounds.height / 2)
        }
    }
    
    private func setupViewmodel() {
        viewModel.pinnedItemsHaveBeenFetched = { [weak self] in
            guard let self = self else { return }
            Spinner.stop()
//            log("\nPinned Items:\nRepositories: \(self.viewModel.pinnedRepositories)\nGists: \(self.viewModel.pinnedGists)")
        }
        viewModel.contributionsHaveBeenFetched = { [weak self] in
            guard let self = self else { return }
            Spinner.stop()
            guard let contributions = self.viewModel.contributionsCollection, contributions.hasAnyContributions else { return }
            self.drawChart()
        }
    }
    
    private func drawChart() {
        let contributionsDays = viewModel.getContributionsDays()
        chartView.updateDataEntries(with: generateEmptyDataEntries(contributionsDays.count), animated: false)
        chartView.updateDataEntries(with: generateDataEntries(for: contributionsDays), animated: true)
        
//        contributionsDays.forEach { day in
//            log("New Day:\nContributions count: \(day.contributionCount)\nColor: \(day.color)\n WeekDay: \(day.weekday.fullName)\nDate: \(day.date)")
//        }
    }
    
    func generateEmptyDataEntries(_ entryNumber: Int) -> [ChartDataEntry] {
        return (0..<entryNumber).map { _ in ChartDataEntry(color: .clear, value: 0, textValue: "0", title: "") }
    }
    
    func generateDataEntries(for contributionsDays: [ContributionsCollection.ContributionDay]) -> [ChartDataEntry] {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return contributionsDays.map { day in
            let color: UIColor = UIColor(hexString: day.color)
            let textValue: String = "\(day.contributionCount)"
            let title: String = formatter.string(from: day.date)
            
            return ChartDataEntry(color: color, value: Float(day.contributionCount), textValue: textValue, title: title)
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
