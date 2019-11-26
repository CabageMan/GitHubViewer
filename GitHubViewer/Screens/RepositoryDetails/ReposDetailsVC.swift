import UIKit

final class ReposDetailsVC: UIViewController {
    
    var repository: Repository
    
    //MARK: - Life Cycle
    init(repository: Repository) {
        self.repository = repository
        super.init(nibName: nil, bundle: nil)
        title = repository.name
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .mainBackground
        
        let backButton = UIBarButtonItem.back { [weak self] in self?.onBackButtonTap() }
        navigationItem.setLeftBarButton(backButton, animated: false)
        
        let menuButtonItem = UIBarButtonItem.menu { [weak self] in self?.onMenuButtonTap() }
        navigationItem.setRightBarButton(menuButtonItem, animated: false)
    }
    
    //MARK: - Actions
    private func onBackButtonTap() {
        dismiss()
    }
    
    private func onMenuButtonTap() {
        Global.showComingSoon()
    }
}
