import UIKit

final class ProfileCollectionCell: UICollectionViewCell {
    
    private let container = UIView()
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    //MARK: - Actions
    private func setup() {
        contentView.backgroundColor = .clear
        
        container.add(to: contentView).do {
            $0.edgesToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        container.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
}

//MARK: - Configure  Cell
extension ProfileCollectionCell: ConfigurableCell {
    typealias CellData = ProfileItem
    
    func configure(with data: ProfileItem) {
        switch data {
        case .user(let user):
            configureUserContent(user: user)
        case .pinned(let pinnedItems):
            configurePinnedContent(items: pinnedItems)
        case .contributions(let contributions, let completion):
            configureContributionsChart(contributions: contributions, completion: completion)
        default: break
        }
    }
    
    private func configureUserContent(user: User) {
        UserCard().add(to: container).do {
            $0.topToSuperview(offset: Theme.contentSideOffset)
            $0.leftToSuperview(offset: Theme.contentSideOffset)
            $0.rightToSuperview(offset: -Theme.contentSideOffset)
            $0.bottomToSuperview(offset: -Theme.contentSideOffset)
            $0.configure(with: user)
        }
    }
    
    private func configurePinnedContent(items: ProfileItem.PinnedItems) {
        log("-----\n")
        log("Pinned Repositories")
        items.repositories.forEach { repository in log("Repository Name: \(repository.name)") }
        log("\nPinned Items:")
        items.gists.forEach { gist in log("Gist Name \(gist.name)") }
    }
    
    private func configureContributionsChart(contributions: [ContributionsCollection.ContributionDay], completion: @escaping (ContributionsCollection.ContributionDay) -> Void) {
        let chartView = BarChartView().add(to: container).then {
            $0.centerInSuperview()
            $0.width(BarChartView.Theme.chartViewFrame.width)
            $0.height(BarChartView.Theme.chartViewFrame.height)
            $0.barHasTouched = { [weak self] barIndex in
                guard let self = self, let index = barIndex else { return }
                let day = contributions[index]
                completion(day)
            }
        }
        chartView.updateDataEntries(with: generateEmptyDataEntries(contributions.count), animated: false)
        chartView.updateDataEntries(with: generateDataEntries(for: contributions), animated: true)
        
//        let yearSelector = YearSelector()
//        yearSelector.selectorContainer.add(to: container).do {
//            $0.centerXToSuperview()
//            $0.width(UIScreen.main.bounds.width - 20.0)
//            $0.topToBottom(of: chartView, offset: Theme.contentSideOffset)
//        }
//        yearSelector.yearDidSelect = { [weak self] selectedYear in
//            guard let self = self else { return }
//            Spinner.start()
//            let selectedYearBounds = self.viewModel.getBoundsOfYear(selectedYear)
//            self.viewModel.getContributionsHistory(fromDate: selectedYearBounds.start, toDate: selectedYearBounds.end)
//        }
    }
}

//MARK: - Chart View Methods
extension ProfileCollectionCell {
    
    private func generateEmptyDataEntries(_ entryNumber: Int) -> [ChartDataEntry] {
        return (0..<entryNumber).map { _ in ChartDataEntry(color: .clear, value: 0, textValue: "0", title: "") }
    }

    private func generateDataEntries(for contributionsDays: [ContributionsCollection.ContributionDay]) -> [ChartDataEntry] {
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
extension ProfileCollectionCell {
    enum Theme {
        //Offsets
        static let contentSideOffset: CGFloat = 13.0
    }
}
