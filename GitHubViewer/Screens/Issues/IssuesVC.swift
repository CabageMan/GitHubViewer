import UIKit

final class IssuesVC: UIViewController {
    
    //MARK: - Life Cycle
    init() {
        super.init(nibName: nil, bundle: nil)
        title = String.Issues.title
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .mainBackground
        
        let menuButtonItem = UIBarButtonItem.menu { [weak self] in self?.menuTapped() }
        navigationItem.setRightBarButton(menuButtonItem, animated: false)
    }
    
    //MARK: - Actions
    private func menuTapped() {
        Global.showComingSoon()
    }
}
