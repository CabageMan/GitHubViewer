import UIKit

final class ProfileChartCard: UIView {
    
    private let chartView = BarChartView()
    private let yearSelector = YearSelector()
    
    var chartBarSelected: (Int) -> Void = { _ in }
    var yearSelected: (Int) -> Void = { _ in }
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    //MARK: - Private Actions
    private func setupUI() {
        chartView.add(to: self).do {
            $0.topToSuperview()
            $0.centerXToSuperview()
            $0.width(BarChartView.Theme.chartViewFrame.width)
            $0.height(BarChartView.Theme.chartViewFrame.height)
            $0.barHasTouched = { [weak self] barIndex in
                guard let index = barIndex else { return }
                self?.chartBarSelected(index)
            }
        }
        
        yearSelector.selectorContainer.add(to: self).do {
            $0.centerXToSuperview()
            $0.topToBottom(of: chartView, offset: Theme.contentSideOffset)
            $0.width(BarChartView.Theme.chartViewFrame.width)
        }
        yearSelector.yearDidSelect = { [weak self] selectedYear in self?.yearSelected(selectedYear) }
    }
    
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
    
    //MARK: - Public Actions
    func updateChart(days: [ContributionsCollection.ContributionDay]) {
        chartView.updateDataEntries(with: generateEmptyDataEntries(days.count), animated: false)
        chartView.updateDataEntries(with: generateDataEntries(for: days), animated: true)
    }
    
    func updateSelectorView(years: [Int], startedAt: Int?) {
        yearSelector.update(with: years, selectedYear: startedAt)
    }
}

//MARK: - Theme
extension ProfileChartCard {
    enum Theme {
        // Offsets
        static let contentSideOffset: CGFloat = 10.0
    }
}
