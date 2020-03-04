import UIKit

final class BarChartView: UIView {
    
    //MARK: - Public Properties
    var barWidth: CGFloat = Theme.barWidth
    var barsSpace: CGFloat = Theme.barsSpace
    
    //MARK: - Private Properties
    private let emptyMessageLabel = UILabel()
    private let chartScrollView = UIScrollView()
    private let chartLayer: CALayer = CALayer()
    private var animated: Bool = false
    private var chartPresenter: BarChartPresenter {
        return BarChartPresenter(viewHeight: self.frame.size.height, barWidth: Theme.barWidth, barsSpace: Theme.barsSpace)
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
    }
    
    //MARK: - Overrides
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        updateDataEntries(with: dataEntries)
//    }
    
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
        chartLayer.addTextLayer(frame: entry.textValueFrame, oldFrame: oldEntry?.textValueFrame, color: color, fontSize: 14, text: entry.data.textValue, animated: animated)
        chartLayer.addTextLayer(frame: entry.titleFrame, oldFrame: oldEntry?.titleFrame, color: Theme.titleColor.cgColor, fontSize: 14, text: entry.data.title, animated: animated)
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
}

extension BarChartView {
    enum Theme {
        // Fonts
        static let emptyMessageFont: UIFont = .cf(style: .compactDisplayThin, size: 23.0)
        // Colors
        static let horiZontalLineColor: UIColor = #colorLiteral(red: 0.8039215686, green: 0.8039215686, blue: 0.8039215686, alpha: 1) // #CDCDCD
        static let titleColor: UIColor = #colorLiteral(red: 0.462745098, green: 0.462745098, blue: 0.462745098, alpha: 1) // #767676
        static let barEndColor: UIColor = #colorLiteral(red: 0.8784313725, green: 0.968627451, blue: 0.6980392157, alpha: 1) // #E0F7B2
        
        // Sizes
        static let barWidth: CGFloat = 40.0
        static let barsSpace: CGFloat = 20.0
    }
}

//import UIKit
//
//final class ChartView: UIView {
//
//    // Fake Data
//    var chartPoints = [4, 2, 6, 4, 5, 8, 3]
//
//    //MARK: -Initializers
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setup()
//    }
//
//    private func setup() {
//        backgroundColor = .clear
//    }
//
//    //MARK: -Draw
//    override func draw(_ rect: CGRect) {
//        guard let context = UIGraphicsGetCurrentContext() else { return }
//
//        UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: Theme.cornerRadius).addClip()
//
//        context.drawLinearGradient(
//            drawGradient(for: rect, startColor: Theme.startColor, endColor: Theme.endColor),
//            start: CGPoint.zero,
//            end: CGPoint(x: 0.0, y: bounds.height),
//            options: []
//        )
//
//        drawChart(in: rect, context: context)
//    }
//
//    //MARK: -Actions
//    private func drawGradient(for rect: CGRect, startColor: UIColor, endColor: UIColor) -> CGGradient {
//        let colors = [startColor.cgColor, endColor.cgColor]
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let colorLocations: [CGFloat] = [0.0, 1.0]
//        return CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations)!
//    }
//
//    private func drawChart(in rect: CGRect, context: CGContext) {
//        let chartWidth = rect.width - Theme.margin * 2 - 4
//        let columnXPoint = { [weak self] (column: Int) -> CGFloat in
//            guard let self = self else { return 0.0 }
//            let spacing = chartWidth / CGFloat(self.chartPoints.count - 1)
//            return CGFloat(column) * spacing + Theme.margin + 2
//        }
//
//        let chartHeight = rect.height - Theme.topBorder - Theme.bottomBorder
//        let maxValue = chartPoints.max()!
//        let columnYPoint = { (graphPoint: Int) -> CGFloat in
//            let y = CGFloat(graphPoint) / CGFloat(maxValue) * chartHeight
//            return chartHeight + Theme.topBorder - y
//        }
//
//        UIColor.white.setFill()
//        UIColor.white.setStroke()
//
//        // Draw chart
//        let chartPath = UIBezierPath().then { path in
//            path.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(chartPoints[0])))
//            (1..<chartPoints.count).forEach {
//                path.addLine(to: CGPoint(x: columnXPoint($0), y: columnYPoint(chartPoints[$0])))
//            }
//        }
//
//        // Draw chart gradient
//        context.saveGState()
//        let clippingPath = chartPath.copy() as! UIBezierPath
//        clippingPath.do {
//            $0.addLine(to: CGPoint(x: columnXPoint(chartPoints.count - 1), y: rect.height))
//            $0.addLine(to: CGPoint(x: columnXPoint(0), y: rect.height))
//            $0.close()
//            $0.addClip()
//        }
//
//        let highestYPoint = columnYPoint(maxValue)
//        let chartStartPoint = CGPoint(x: Theme.margin, y: highestYPoint)
//        let chartEndPoint = CGPoint(x: Theme.margin, y: bounds.height)
//        context.drawLinearGradient(
//            drawGradient(for: rect, startColor: Theme.chartStartColor, endColor: Theme.chartEndColor),
//            start: chartStartPoint,
//            end: chartEndPoint,
//            options: []
//        )
//        context.restoreGState()
//
//        chartPath.do {
//            $0.lineWidth = 2.0
//            $0.stroke()
//        }
//
//        (0..<chartPoints.count).forEach {
//            var point = CGPoint(x: columnXPoint($0), y: columnYPoint(chartPoints[$0]))
//            point.x -= Theme.circleDiameter / 2
//            point.y -= Theme.circleDiameter / 2
//            UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(Theme.circleDiameter))).fill()
//
//        }
//    }
//}
//
////MARK: -Theme
//extension ChartView {
//    enum Theme {
//        // Colors
//        static let chartStartColor: UIColor = #colorLiteral(red: 0.09803921569, green: 0.3803921569, blue: 0.1529411765, alpha: 1) // #196127
//        static let chartEndColor: UIColor = #colorLiteral(red: 0.7764705882, green: 0.8941176471, blue: 0.5450980392, alpha: 1) // #c6e48b
//        static let startColor: UIColor = #colorLiteral(red: 0.9803921569, green: 0.9137254902, blue: 0.8705882353, alpha: 1) // #FAE9DE
//        static let endColor: UIColor = #colorLiteral(red: 0.9882352941, green: 0.3098039216, blue: 0.03137254902, alpha: 1) // #FC4F08
//
//        static let colorAlpha: CGFloat = 0.3
//
//        // Sizes
//        static let cornerRadius = CGSize(13.0)
//        static let margin: CGFloat = 20.0
//        static let topBorder: CGFloat = 60.0
//        static let bottomBorder: CGFloat = 50.0
//        static let circleDiameter: CGFloat = 5.0
//    }
//}
