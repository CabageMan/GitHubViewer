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
            log("\nPinned Items:\nRepositories: \(self.viewModel.pinnedRepositories)\nGists: \(self.viewModel.pinnedGists)")
        }
        viewModel.contributionsHaveBeenFetched = { [weak self] in
            guard let self = self else { return }
            Spinner.stop()
            guard let contributions = self.viewModel.contributionsCollection, contributions.hasAnyContributions else { return }
            log("Colors: \(contributions.calendar.colors)")
            contributions.calendar.weeks.forEach {
                log("\nNew week")
                $0.days.forEach {
                    log("Full day name: \($0.weekday.fullName)")
                }
            }
            
            self.drawChart()
        }
    }
    
    private func drawChart() {
        let dataEntries = generateEmptyDataEntries()
        chartView.updateDataEntries(with: dataEntries, animated: false)
        
        
        let timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) {[unowned self] (timer) in
            let dataEntries = self.generateRandomDataEntries()
            self.chartView.updateDataEntries(with: dataEntries, animated: true)
        }
        timer.fire()
    }
}

//MARK: - Fake Data
extension ProfileVC {
    
    var numEntry: Int {
        return 20
    }
    
    func generateEmptyDataEntries() -> [ChartDataEntry] {
        var result: [ChartDataEntry] = []
        Array(0..<numEntry).forEach {_ in
            result.append(ChartDataEntry(color: UIColor.clear, height: 0, textValue: "0", title: ""))
        }
        return result
    }

    func generateRandomDataEntries() -> [ChartDataEntry] {
        let colors = [#colorLiteral(red: 0.7764705882, green: 0.8941176471, blue: 0.5450980392, alpha: 1), #colorLiteral(red: 0.4823529412, green: 0.7882352941, blue: 0.4352941176, alpha: 1), #colorLiteral(red: 0.137254902, green: 0.6039215686, blue: 0.231372549, alpha: 1), #colorLiteral(red: 0.09803921569, green: 0.3803921569, blue: 0.1529411765, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
        var result: [ChartDataEntry] = []
        for i in 0..<numEntry {
            let value = (arc4random() % 90) + 10
            let height: Float = Float(value) / 100.0
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM"
            var date = Date()
            date.addTimeInterval(TimeInterval(24*60*60*i))
            result.append(ChartDataEntry(color: colors[i % colors.count], height: height, textValue: "\(value)", title: formatter.string(from: date)))
        }
        return result
    }
    
}

//MARK: - Theme
extension ProfileVC {
    enum Theme {
        // Offsets
        static let emptyViewOffset: CGFloat = 70.0
    }
}
