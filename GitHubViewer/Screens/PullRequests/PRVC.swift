import UIKit

final class PRVC: UIViewController {
    
    private let router: RepositoriesRouter
    
    //MARK: - Life Cycle
    init(router: RepositoriesRouter) {
        self.router = router
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
        
        let menuButtonItem = UIBarButtonItem.menu { [weak self] in self?.menuTapped() }
        navigationItem.setRightBarButton(menuButtonItem, animated: false)
        
        EmptyView.createEmptyPullRequests(offset: -Theme.emptyViewOffset).add(to: view).do {
            $0.edgesToSuperview()
        }
    }
    
    //MARK: - Actions
    private func menuTapped() {
        // Configure and then call settings
        router.showSetiings()
    }
}

//MARK: - Theme
extension PRVC {
    enum Theme {
        // Offsets
        static let emptyViewOffset: CGFloat = 70.0
    }
}
