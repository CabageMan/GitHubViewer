import Foundation
import CoreGraphics.CGGeometry

final class BarChartPresenter {

    private let viewHeight: CGFloat
    private let barWidth: CGFloat
    private let barsSpace: CGFloat
    
    //MARK: -Initializers
    init(viewHeight: CGFloat, barWidth: CGFloat, barsSpace: CGFloat) {
        self.viewHeight = viewHeight
        self.barWidth = barWidth
        self.barsSpace = barsSpace
    }
    
    //MARK: -Actions
    func calculateContentWidth(for entriesNumber: Int) -> CGFloat {
        return (barWidth + barsSpace) * CGFloat(entriesNumber) + barsSpace
    }
    
    func createBarEntries(for data: [ChartDataEntry]) -> [ChartBarEntry] {
        return data.enumerated().map { index, entry in
            let entryHeight = CGFloat(entry.height) * (viewHeight - Theme.textValueSpace - Theme.titleSpace)
            let xPosition = barsSpace + CGFloat(index) * (barWidth + barsSpace)
            let yPosition = viewHeight - Theme.titleSpace - entryHeight
            
            return ChartBarEntry(
                origin: CGPoint(x: xPosition, y: yPosition),
                barWidth: barWidth,
                barHeight: entryHeight,
                space: barsSpace,
                data: entry
            )
        }
    }
    
    func createHorizontalLnes(for entriesNumber: Int) -> [HorizontalLine] {
        let linesStyles = [
            (position: CGFloat(0.0), isDashed: false),
            (position: CGFloat(0.5), isDashed: true),
            (position: CGFloat(1.0), isDashed: false)
        ]
        return linesStyles.map {
            let yPosition = viewHeight - Theme.titleSpace - $0.position * (viewHeight - Theme.textValueSpace - Theme.titleSpace)
            let lineSegment = LineSegment(
                startPoint: CGPoint(x: 0.0, y: yPosition),
                endPoint: CGPoint(x: calculateContentWidth(for: entriesNumber), y: yPosition)
            )
            return HorizontalLine(
                segment: lineSegment,
                isDashed: $0.isDashed,
                width: Theme.horizontsalLinesWidth
            )
        }
    }
}

extension BarChartPresenter {
    enum Theme {
        // Offsets
        static let textValueSpace: CGFloat = 40.0
        static let titleSpace: CGFloat = 40.0
        
        // Sizes
        static let horizontsalLinesWidth: CGFloat = 0.5
    }
}
