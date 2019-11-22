import UIKit

final class PRVC: UIViewController {
    
    //MARK: - Life Cycle
    init() {
        super.init(nibName: nil, bundle: nil)
        title = String.Pr.title
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .mainBackground
        
        let menuButtonItem = UIBarButtonItem.rightButton(image: #imageLiteral(resourceName: "menu20")) { [weak self] in self?.menuTapped() }
        navigationItem.setRightBarButton(menuButtonItem, animated: false)
    }
    
    //MARK: - Actions
    private func menuTapped() {
        Global.showComingSoon()
    }
}
