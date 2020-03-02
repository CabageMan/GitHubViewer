import UIKit

final class YearSelector: NSObject {
    #warning("May be add custom date selector to years selector")
    //MARK: - Publick Properties
    let selectorContainer = ScrollableStack(axis: .horizontal, spacing: Theme.itemsSpace, distribution: .fill)
    var yearDidSelect: (Int) -> Void = { _ in }
    
    //MARK: - Private Properties
    
    private let contributionsYears: [Int]
    private var previousSelectedItem: YearSelectorItem?
    
    //MARK: - Initializers
    init(years: [Int]) {
        self.contributionsYears = years
        super.init()
        setup()
    }
    
    private func setup() {
        selectorContainer.do {
            $0.height(YearSelectorItem.Theme.itemHeight)
            $0.stackView.addArrangedSubviews(createYearsItems())
            $0.scrollView.alwaysBounceVertical = false
        }
    }
    
    // Actions
    private func createYearsItems() -> [UIView] {
        return contributionsYears.map { year in
            YearSelectorItem(year: year).then {
                $0.itemDidSelect = { [weak self] in self?.selectItem($0) }
            }
        }
    }
    
    private func selectItem(_ item: YearSelectorItem) {
        if let selectedItem = previousSelectedItem {
            selectedItem.isSelected = false
        }
        item.do {
            previousSelectedItem = $0
            $0.isSelected = true
            yearDidSelect($0.year)
        }
    }
}

extension YearSelector {
    enum Theme {
        // Offsets
        static let itemsSpace: CGFloat = 8.0
    }
}
