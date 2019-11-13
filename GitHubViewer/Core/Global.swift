import UIKit

struct Global {
    //MARK: - Static Properties
    
    //MARK: - Alert Messages
    static func showCustomMessage(message: String) {
      let alert = UIAlertController(title: "🔥", message: message, preferredStyle: .alert)
      alert.addAction(.ok())
      UIViewController.current?.present(alert, animated: true, completion: nil)
    }
    
    static func showComingSoon() {
        let alert = UIAlertController(title: "🔥", message: String.General.comingSoon, preferredStyle: .alert)
        alert.addAction(.ok())
        UIViewController.current?.present(alert, animated: true, completion: nil)
    }
}

//MARK: - Logging
func log(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        Swift.print(formatter.string(from: Date()), " -- ", items[0], separator: separator, terminator: terminator)
    #endif
}
