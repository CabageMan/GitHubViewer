import UIKit

extension UIScrollView {
    var isEndOfScroll: Bool {
        #warning("Need to consider direction of scrolling")
        return contentOffset.y >= 0 && contentOffset.y >= (contentSize.height - frame.size.height)
    }
}
