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
        
        let menuButtonItem = UIBarButtonItem.menu { [weak self] in self?.menuTapped() }
        navigationItem.setRightBarButton(menuButtonItem, animated: false)
        
        EmptyView.createEmptyPullRequests(offset: -Theme.emptyViewOffset).add(to: view).do {
            $0.edgesToSuperview()
        }
    }
    
    //MARK: - Actions
    private func menuTapped() {
        Global.showComingSoon()
    }
}

//MARK: - Theme
extension PRVC {
    enum Theme {
        // Offsets
        static let emptyViewOffset: CGFloat = 70.0
    }
}
