import UIKit

final class PullRequestDetailsVC: UIViewController {
    
    private let router: RepositoriesRouter
    
    private let pullRequest: PullRequest
    private let requestNameLabel = UILabel()
    private let requestStateView: PullRequestStateView
    
    private let commitsCollection = GitHubViewerCollection<PullRequestDetailsCollectionCell>(mode: .commits)
    
    //MARK: - Life Cycle
    init(router: RepositoriesRouter, pullRequest: PullRequest) {
        self.router = router
        self.pullRequest = pullRequest
        self.requestStateView = {
            switch pullRequest.state {
            case .open: return PullRequestStateView(mode: .open)
            case .merged: return PullRequestStateView(mode: .merged)
            case .closed: return PullRequestStateView(mode: .closed)
            default: return PullRequestStateView(mode: .unknown)
            }
        }()
        super.init(nibName: nil, bundle: nil)
        title = pullRequest.baseRepository?.resourcePath
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .mainBackground
        
        let backButton = UIBarButtonItem.back { [weak self] in self?.dismiss() }
        navigationItem.setLeftBarButton(backButton, animated: false)
        
        let menuButtonItem = UIBarButtonItem.menu { [weak self] in self?.router.showMenu() }
        navigationItem.setRightBarButton(menuButtonItem, animated: false)
        
        requestNameLabel.add(to: view).do {
            $0.topToSuperview(offset: Theme.nameLabelTopOffset)
            $0.leftToSuperview(offset: Theme.nameLabelSideOffset)
            $0.height(Theme.requestNameLabelheight)
            $0.textAlignment = .left
            $0.font = Theme.requestNameFont
            $0.textColor = .darkCoal
            let requestName = (pullRequest.title + " ").attributed.paint(with: .darkCoal)
            let requestNumber = String.Pr.pullRequestNumber("\(pullRequest.number)").attributed.paint(with: .textGray)
            $0.attributedText = requestName + requestNumber
        }
        
        requestStateView.add(to: view).do {
            $0.topToBottom(of: requestNameLabel)
            $0.left(to: requestNameLabel)
            $0.height(Theme.stateViewHeight)
        }
        
        commitsCollection.collectionView.add(to: view).do {
            $0.edgesToSuperview(excluding: .top)
            $0.topToBottom(of: requestStateView)
        }
        commitsCollection.onCellTap = { commit in
            Global.showCustomMessage(message: "\(commit.message)")
        }
        commitsCollection.getNextData = {
            Global.showCustomMessage(message: "We need to load more data")
        }
        commitsCollection.items = pullRequest.commits
    }
}

//MARK: - Theme
extension PullRequestDetailsVC {
    enum Theme {
        // Fonts
        static var requestNameFont: UIFont {
            switch Device.realDiagonal {
            case Device.iPhone5.diagonal: return .circular(style: .bold, size: 14.0)
            case Device.iPhone6.diagonal: return .circular(style: .bold, size: 16.0)
            case Device.iPhone6Plus.diagonal: return .circular(style: .bold, size: 18.0)
            case Device.iPhoneX.diagonal: return .circular(style: .bold, size: 16.0)
            case Device.iPhoneXsMax.diagonal: return .circular(style: .bold, size: 18.0)
            case Device.iPhone11ProMax.diagonal: return .circular(style: .bold, size: 18.0)
            default: return .circular(style: .bold, size: 14.0)
            }
        }
        
        // Sizes
        static let requestNameLabelheight: CGFloat = 25.0
        static let stateViewHeight: CGFloat = 30.0
        
        // Offsets
        static let nameLabelSideOffset: CGFloat = 8.0
        static let nameLabelTopOffset: CGFloat = 13.0
    }
}
