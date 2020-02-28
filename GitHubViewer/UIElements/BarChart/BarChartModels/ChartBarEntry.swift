import Foundation
import CoreGraphics.CGGeometry

struct ChartBarEntry {
    let origin: CGPoint
    let barWidth: CGFloat
    let barHeight: CGFloat
    let space: CGFloat
    let data: ChartDataEntry
    
    var titleFrame: CGRect {
        return CGRect(
            x: origin.x - space / 2,
            y: origin.y + Theme.titleTopOffset + barHeight,
            width: barWidth + space,
            height: Theme.titleHeight
        )
    }
    var textValueFrame: CGRect {
        return CGRect(
            x: origin.x - space / 2,
            y: origin.y - Theme.textValueBottomOffset,
            width: barWidth + space,
            height: Theme.textValueHeight
        )
    }
    var barFrame: CGRect {
        return CGRect(
            x: origin.x,
            y: origin.y,
            width: barWidth,
            height: barHeight
        )
    }
}

extension ChartBarEntry {
    enum Theme {
        // Sizes
        static let titleHeight: CGFloat = 22.0
        static let textValueHeight: CGFloat = 22.0
        
        // Offsets
        static let titleTopOffset: CGFloat = 10.0
        static let textValueBottomOffset: CGFloat = 30.0
    }
}
