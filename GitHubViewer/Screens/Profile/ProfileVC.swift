import UIKit

final class ProfileVC: UIViewController {
    
    private let router: GithubViewerRouter
    private let viewModel: ProfileVM
    
    //MARK: - Life Cycle
    init(router: GithubViewerRouter) {
        self.router = router
        self.viewModel = ProfileVM()
        super.init(nibName: nil, bundle: nil)
        title = String.Profile.title
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.getPinnedItems()
    }
    
    private func setupUI() {
        view.backgroundColor = .mainBackground
        
        let menuButtonItem = UIBarButtonItem.menu { [weak self] in self?.router.showMenu() }
        navigationItem.setRightBarButton(menuButtonItem, animated: false)
        
        EmptyView.createEmptyProfile(offset: -Theme.emptyViewOffset).add(to: view).do {
            $0.edgesToSuperview()
        }
    }
}

//MARK: - Theme
extension ProfileVC {
    enum Theme {
        // Offsets
        static let emptyViewOffset: CGFloat = 70.0
    }
}
