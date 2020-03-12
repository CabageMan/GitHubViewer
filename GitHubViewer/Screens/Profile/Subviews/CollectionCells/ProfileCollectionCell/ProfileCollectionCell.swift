import UIKit

final class ProfileCollectionCell: UICollectionViewCell {
    
    private let container = UIView()
    private var yearSelector: YearSelector?
    
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
        case .contributions(let contributions):
            configureContributionsChart(
                days: contributions.contributionsDays,
                years: contributions.contributionsYears,
                startedAt: contributions.contributionsStartedAt,
                onBarSelect: contributions.onBarSelect,
                onYearSelect: contributions.onYearSelect
            )
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
    
    private func configureContributionsChart(days: [ContributionsCollection.ContributionDay], years: [Int], startedAt: Int?, onBarSelect: @escaping (ContributionsCollection.ContributionDay) -> Void, onYearSelect: @escaping (Int) -> Void) {
        let chartView = BarChartView().add(to: container).then {
            $0.topToSuperview()
            $0.leftToSuperview(offset: Theme.contentSideOffset)
            $0.width(BarChartView.Theme.chartViewFrame.width)
            $0.height(BarChartView.Theme.chartViewFrame.height)
            $0.barHasTouched = { barIndex in
                guard let index = barIndex else { return }
                onBarSelect(days[index])
            }
        }
        chartView.updateDataEntries(with: generateEmptyDataEntries(days.count), animated: false)
        chartView.updateDataEntries(with: generateDataEntries(for: days), animated: true)
        
        #warning("Check and fix year selector")
        yearSelector = YearSelector()
        yearSelector!.selectorContainer.add(to: container).do {
            $0.centerXToSuperview()
            $0.width(BarChartView.Theme.chartViewFrame.width)
            $0.topToBottom(of: chartView, offset: Theme.contentSideOffset)
        }
        yearSelector!.yearDidSelect = { selectedYear in
            log("Selected year is: \(selectedYear)")
            onYearSelect(selectedYear)
        }
        yearSelector!.update(with: years, selectedYear: startedAt)
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
        static let contentSideOffset: CGFloat = 10.0
    }
}
