import UIKit

final class ChartView: UIView {
    
    // Fake Data
    var chartPoints = [4, 2, 6, 4, 5, 8, 3]
    
    //MARK: -Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
    }
    
    //MARK: -Draw
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: Theme.cornerRadius).addClip()
        
        context.drawLinearGradient(
            drawGradient(for: rect),
            start: CGPoint.zero,
            end: CGPoint(x: 0.0, y: bounds.height),
            options: []
        )
        
        drawChart(in: rect, context: context)
    }
    
    //MARK: -Actions
    private func drawGradient(for rect: CGRect) -> CGGradient {
        let colors = [Theme.startColor.cgColor, Theme.endColor.cgColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 1.0]
        return CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations)!
    }
    
    private func drawChart(in rect: CGRect, context: CGContext) {
        let chartWidth = rect.width - Theme.margin * 2 - 4
        let columnXPoint = { [weak self] (column: Int) -> CGFloat in
            guard let self = self else { return 0.0 }
            let spacing = chartWidth / CGFloat(self.chartPoints.count - 1)
            return CGFloat(column) * spacing + Theme.margin + 2
        }
        
        let chartHeight = rect.height - Theme.topBorder - Theme.bottomBorder
        let maxValue = chartPoints.max()!
        let columnYPoint = { (graphPoint: Int) -> CGFloat in
            let y = CGFloat(graphPoint) / CGFloat(maxValue) * chartHeight
            return chartHeight + Theme.topBorder - y
        }
        
        UIColor.white.setFill()
        UIColor.white.setStroke()
        
        // Draw chart
        let chartPath = UIBezierPath().then { path in
            path.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(chartPoints[0])))
            (1..<chartPoints.count).forEach {
                path.addLine(to: CGPoint(x: columnXPoint($0), y: columnYPoint(chartPoints[$0])))
            }
        }
        
        // Draw chart gradient
        let clippingPath = chartPath.copy() as! UIBezierPath
        clippingPath.do {
            $0.addLine(to: CGPoint(x: columnXPoint(chartPoints.count - 1), y: rect.height))
            $0.addLine(to: CGPoint(x: columnXPoint(0), y: rect.height))
            $0.close()
            $0.addClip()
        }
        
        let highestYPoint = columnYPoint(maxValue)
        let chartStartPoint = CGPoint(x: Theme.margin, y: highestYPoint)
        let chartEndPoint = CGPoint(x: Theme.margin, y: bounds.height)
        context.drawLinearGradient(
            drawGradient(for: rect),
            start: chartStartPoint,
            end: chartEndPoint,
            options: []
        )
        
        chartPath.do {
            $0.lineWidth = 2.0
            $0.stroke()
        }
    }
}

//MARK: -Theme
extension ChartView {
    enum Theme {
        // Colors
        static let startColor: UIColor = #colorLiteral(red: 0.9803921569, green: 0.9137254902, blue: 0.8705882353, alpha: 1) // #FAE9DE
        static let endColor: UIColor = #colorLiteral(red: 0.9882352941, green: 0.3098039216, blue: 0.03137254902, alpha: 1) // #FC4F08
        static let colorAlpha: CGFloat = 0.3
        
        // Sizes
        static let cornerRadius = CGSize(13.0)
        static let margin: CGFloat = 20.0
        static let topBorder: CGFloat = 60.0
        static let bottomBorder: CGFloat = 50.0
        static let circleDiameter: CGFloat = 5.0
    }
}
