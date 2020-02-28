import UIKit

struct ChartDataEntry {
    let color: UIColor
    let height: Float
    let textValue: String
    let title: String
    
    init(color: UIColor, height: Float, textValue: String, title: String) {
        assert(height >= 0.0 && height <= 1.0, "Wrong height value. Height must be in range from 0.0 to 1.0")
        self.color = color
        self.height = height
        self.textValue = textValue
        self.title = title
    }
}
