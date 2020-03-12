import UIKit

final class BarChartView: UIView {
    
    //MARK: - Public Properties
    var barWidth: CGFloat = Theme.barWidth
    var barsSpace: CGFloat = Theme.barsSpace
    var barHasTouched: (Int?) -> Void = { _ in }
    
    //MARK: - Private Properties
    private let emptyMessageLabel = UILabel()
    private let chartScrollView = UIScrollView()
    private let chartLayer: CALayer = CALayer()
    private var animated: Bool = false
    private var chartPresenter: BarChartPresenter {
        return BarChartPresenter(viewHeight: self.frame.size.height, barWidth: Theme.barWidth, barsSpace: barsSpace)
    }
    private var dataEntries: [ChartDataEntry] = []
    private var barEntries: [ChartBarEntry] = [] {
        didSet { updateChart(oldValue) }
    }
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        layer.frame = Theme.chartViewFrame
        CAGradientLayer().add(to: self.layer).do {
            $0.frame = self.frame
            $0.colors = [Theme.gradientStartColor, Theme.gradientEndColor]
            $0.cornerRadius = Theme.cornerRadius
        }
        emptyMessageLabel.add(to: self).do {
            $0.centerInSuperview()
            $0.widthToSuperview()
            $0.font = Theme.emptyMessageFont
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.textColor = Theme.titleColor
            $0.text = String.EmptyView.emptyContributions
            $0.isHidden = true
        }
        chartScrollView.add(to: self).do {
            $0.layer.addSublayer(chartLayer)
            $0.edgesToSuperview()
        }
        chartScrollView.addGesture(type: .tap) { [weak self] recognizer in self?.getTappedBar(recognizer: recognizer) }
    }
    
    //MARK: - Public Actions
    func updateDataEntries(with dataEntries: [ChartDataEntry], animated: Bool = false) {
        self.animated = animated
        self.dataEntries = dataEntries
        self.barEntries = chartPresenter.createBarEntries(for: dataEntries)
    }
    
    //MARK: - Private Actions
    private func updateChart(_ oldEntries: [ChartBarEntry]?) {
        chartLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        chartScrollView.contentSize = CGSize(width: chartPresenter.calculateContentWidth(for: barEntries.count), height: self.frame.size.height)
        chartScrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
        chartLayer.frame = CGRect(x: 0.0, y: 0.0, width: chartScrollView.contentSize.width, height: chartScrollView.contentSize.height)
        if barEntries.isEmpty {
            emptyMessageLabel.isHidden = false
        } else {
            emptyMessageLabel.isHidden = true
            showHorisontalLines(for: barEntries.count)
            barEntries.enumerated().forEach { index, entry in
                showEntry(index: index, entry: entry, oldEntry: oldEntries?.safeValue(at: index), animated: animated)
            }
        }
    }
    
    private func showEntry(index: Int, entry: ChartBarEntry, oldEntry: ChartBarEntry?, animated: Bool) {
        let color = entry.data.color.cgColor
        chartLayer.addRectangleLayer(frame: entry.barFrame, oldFrame: oldEntry?.barFrame, startColor: color, endColor: Theme.barEndColor.cgColor, animated: animated)
        chartLayer.addTextLayer(frame: entry.textValueFrame, oldFrame: oldEntry?.textValueFrame, color: color, fontSize: Theme.chartBarFontSize, text: entry.data.textValue, animated: animated)
        chartLayer.addTextLayer(frame: entry.titleFrame, oldFrame: oldEntry?.titleFrame, color: Theme.titleColor.cgColor, fontSize: Theme.chartBarFontSize, text: entry.data.title, animated: animated)
    }
    
    private func showHorisontalLines(for barsNumber: Int) {
        self.layer.sublayers?.forEach {
            if $0 is CAShapeLayer {
                $0.removeFromSuperlayer()
            }
        }
        chartPresenter.createHorizontalLines(for: barsNumber).forEach {
            chartLayer.addLineLayer(lineSegment: $0.segment, oldSegment: nil, color: Theme.horiZontalLineColor.cgColor, width: $0.width, isDashed: $0.isDashed, animated: false)
        }
    }
    
    private func getTappedBar(recognizer: UIGestureRecognizer) {
        let tapPosition = recognizer.location(in: chartScrollView)
        barEntries.forEach {
            guard tapPosition.y >= self.frame.size.height - $0.barFrame.height - $0.titleFrame.height - $0.textValueFrame.height else { return }
            if (tapPosition.x >= $0.barFrame.origin.x) && (tapPosition.x <= ($0.barFrame.origin.x + $0.barFrame.width)) {
                barHasTouched(barEntries.firstIndex(of: $0))
            }
        }
    }
}

extension BarChartView {
    enum Theme {
        // Fonts
        static let emptyMessageFont: UIFont = .cf(style: .compactDisplayThin, size: 23.0)
        
        // Colors
        static let horiZontalLineColor: UIColor = #colorLiteral(red: 0.8039215686, green: 0.8039215686, blue: 0.8039215686, alpha: 1) // #CDCDCD
        static let titleColor: UIColor = #colorLiteral(red: 0.462745098, green: 0.462745098, blue: 0.462745098, alpha: 1) // #767676
        static let barEndColor: UIColor = #colorLiteral(red: 0.8784313725, green: 0.968627451, blue: 0.6980392157, alpha: 1) // #E0F7B2
        static let gradientStartColor: CGColor = #colorLiteral(red: 0.8823529412, green: 0.9490196078, blue: 0.9960784314, alpha: 1).cgColor // #E1F2FE
        static let gradientEndColor: CGColor = #colorLiteral(red: 0.5960784314, green: 0.8235294118, blue: 0.9215686275, alpha: 1).cgColor // #98D2EB
        
        // Sizes
        static let barWidth: CGFloat = 40.0
        static let barsSpace: CGFloat = 20.0
        static let cornerRadius: CGFloat = 13.0
        static let chartBarFontSize: CGFloat = 14.0
        
        // Rects
        static let chartViewFrame: CGRect = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width - 20.0, height: UIScreen.main.bounds.width + 20.0)
    }
}
