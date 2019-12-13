import UIKit

extension UIScrollView {
    var isEndOfScroll: Bool {
        return contentOffset.y >= 0 && contentOffset.y >= (contentSize.height - frame.size.height)
    }
}
