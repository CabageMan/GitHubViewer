import UIKit

final class YearSelectorItem: UIView {
    
    // Public Properties
    let year: Int
    var isSelected: Bool = false {
        didSet { setSelected() }
    }
    var itemDidSelect: (YearSelectorItem) -> Void = { _ in }
    
    // Private Properties
    private let yearLabel = UILabel()
    
    // Initializers
    init(year: Int) {
        self.year = year
        super.init(frame: .zero)
        
        self.do {
            $0.width(Theme.itemWidth)
            $0.height(Theme.itemHeight)
            $0.layer.cornerRadius = Theme.itemCornerRadius
            $0.backgroundColor = .yearSelectorColor
            $0.addGesture(type: .tap) { [weak self] _ in
                guard let self = self else { return }
                self.itemDidSelect(self)
            }
        }
        
        yearLabel.add(to: self).do {
            $0.centerInSuperview()
            $0.width(Theme.yearLabelWidth)
            $0.height(Theme.yearLabelHeigth)
            $0.font = Theme.yearLabelFont
            $0.textAlignment = .center
            $0.textColor = .darkCoal
            $0.text = "\(year)"
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    //MARK: - Actions
    private func setSelected() {
        backgroundColor = isSelected ? .yearSelectorActiveColor : .yearSelectorColor
        yearLabel.textColor = isSelected ? .white : .darkCoal
    }
}

extension YearSelectorItem {
    enum Theme {
        // Fonts
        static let yearLabelFont: UIFont = .circular(style: .medium, size: 9.0)
        
        // Sizes
        static let itemWidth: CGFloat = 123.0
        static let itemHeight: CGFloat = 34.0
        static let itemCornerRadius: CGFloat = 3.0
        static let yearLabelWidth: CGFloat = 27.0
        static let yearLabelHeigth: CGFloat = 9.0
    }
}
