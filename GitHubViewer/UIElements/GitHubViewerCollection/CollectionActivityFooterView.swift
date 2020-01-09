import UIKit

final class CollectionActivityFooterView: UICollectionReusableView {
    
    private let indicator = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        indicator.add(to: self).do {
            $0.centerInSuperview()
            $0.style = .gray
            $0.hidesWhenStopped = true
        }
    }
    
    func startAnimating() {
        indicator.startAnimating()
    }
    
    func stopAnimating() {
        indicator.stopAnimating()
    }
}

//MARK: - Theme
extension CollectionActivityFooterView {
    enum Theme {
        // Sizes
        static let height: CGFloat = 23.0
    }
}
