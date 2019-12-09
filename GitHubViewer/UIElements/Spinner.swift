import UIKit

final class Spinner {
    static var spinner: UIActivityIndicatorView?
    
    static func start() {
        if spinner == nil, let window = UIApplication.shared.keyWindow {
            let frame = UIScreen.main.bounds
            spinner = UIActivityIndicatorView(frame: frame)
            spinner!.backgroundColor = .mainBackground
            spinner!.style = .gray
            spinner?.color = .darkCoal
            window.addSubview(spinner!)
            spinner!.startAnimating()
        }
    }
    
    static func stop() {
        if spinner != nil {
            spinner!.stopAnimating()
            spinner!.removeFromSuperview()
            spinner = nil
        }
    }
}
