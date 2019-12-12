import UIKit

final class SettingsController: UIViewController {
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .cyan
    }
}

//TODO:
// Hide Tab bar on calling
// Check on leaks
// Create setting config
