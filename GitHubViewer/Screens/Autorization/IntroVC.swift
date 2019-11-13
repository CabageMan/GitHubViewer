import UIKit

final class IntroVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        
        log(String.General.welcome)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Global.showCustomMessage(message: String.General.welcome)
    }
}
