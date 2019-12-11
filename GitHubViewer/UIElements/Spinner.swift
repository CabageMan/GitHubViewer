import UIKit

final class Spinner {
    static var spinner: UIActivityIndicatorView?
    
    static func start() {
        guard spinner == nil else { return }
        let frame = UIScreen.main.bounds
        spinner = UIActivityIndicatorView(frame: frame).then {
            $0.backgroundColor = .clear
            $0.style = .gray
            $0.color = .darkCoal
        }
        
        guard let topVC = UIViewController.current else { return }
        spinner!.add(to: topVC.view).do {
            let offset = (frame.height - topVC.view.frame.height) / 2
            $0.centerXToSuperview()
            $0.centerYToSuperview(offset: -offset)
            $0.startAnimating()
        }
    }
    
    static func stop() {
        guard spinner != nil else { return }
        spinner!.do {
            $0.stopAnimating()
            $0.removeFromSuperview()
        }
        spinner = nil
    }
}
