import UIKit

final class YearSelector: NSObject {
    #warning("May be add custom date selector to years selector")
    //MARK: - Publick Properties
    let selectorContainer = ScrollableStack(axis: .horizontal, spacing: Theme.itemsSpace, distribution: .fill)
    var yearDidSelect: (Int) -> Void = { _ in }
    
    //MARK: - Private Properties
    private var currentSelectedItem: YearSelectorItem?
    
    //MARK: - Initializers
    override init() {
        super.init()
        setup()
    }
    
    private func setup() {
        selectorContainer.do {
            $0.height(YearSelectorItem.Theme.itemHeight)
            $0.scrollView.alwaysBounceVertical = false
        }
    }
    
    //MARK: - Public Actions
    func update(with years: [Int], selectedYear: Int?) {
        currentSelectedItem = nil
        selectorContainer.stackView.arrangedSubviews.forEach {
            selectorContainer.stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        selectorContainer.stackView.addArrangedSubviews(createYearsItems(from: years, currentYear: selectedYear))
        scrollToSelectedItem()
    }
    
    //MARK: - Private Actions
    private func createYearsItems(from contributionsYears: [Int], currentYear: Int? = nil) -> [UIView] {
        return contributionsYears.map { year in
            YearSelectorItem(year: year).then {
                if year == currentYear {
                    $0.isSelected = true
                    currentSelectedItem = $0
                }
                $0.itemDidSelect = { [weak self] in self?.selectItem($0) }
            }
        }
    }
    
    private func selectItem(_ item: YearSelectorItem) {
        if let selectedItem = currentSelectedItem {
            selectedItem.isSelected = false
        }
        item.do {
            currentSelectedItem = $0
            $0.isSelected = true
            yearDidSelect($0.year)
        }
    }
    
    private func scrollToSelectedItem() {
        guard let selectedItem = currentSelectedItem,
              let selectedItemIndex = selectorContainer.stackView.arrangedSubviews.firstIndex(of: selectedItem)
        else { return }
        let scrollViewWidth = selectorContainer.scrollView.frame.width
        let lastItemIndex = selectorContainer.stackView.arrangedSubviews.endIndex - 1
        let selectedItemPositionX = CGFloat(selectedItemIndex) * (YearSelectorItem.Theme.itemWidth + Theme.itemsSpace)
        var xPositionToScroll: CGFloat
        if selectedItemIndex == 0 {
            xPositionToScroll = selectedItemPositionX
        } else if selectedItemIndex == lastItemIndex {
            xPositionToScroll = selectedItemPositionX - (scrollViewWidth - YearSelectorItem.Theme.itemWidth)
        } else {
            xPositionToScroll = selectedItemPositionX - (scrollViewWidth / 2 - (YearSelectorItem.Theme.itemWidth) / 2)
        }
        selectorContainer.scrollView.setContentOffset(CGPoint(x: xPositionToScroll, y: 0), animated: true)
    }
}

extension YearSelector {
    enum Theme {
        // Offsets
        static let itemsSpace: CGFloat = 8.0
    }
}
