import UIKit

final class IssueDetailsVC: UIViewController {
    
    private let router: GithubViewerRouter
    
    private let issue: Issue
    private let issueNameLabel = UILabel()
    private let issueStateView: StateView
    private let descriptionLabel = UILabel()
    private let commentsCollection = GitHubViewerCollection<IssueCommentCell>(mode: .issueComments)
    
    //MARK: - Life Cycle
    init(router: GithubViewerRouter, issue: Issue) {
        self.router = router
        self.issue = issue
        self.issueStateView = {
            switch issue.state {
            case .open: return StateView(mode: .issueOpenDetails)
            case .closed: return StateView(mode: .issueClosedDetails)
            default: return StateView(mode: .unknown)
            }
        }()
        super.init(nibName: nil, bundle: nil)
        title = issue.repository.resourcePath
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        commentsCollection.items = issue.comments
    }
    
    private func setupUI() {
        view.backgroundColor = .mainBackground
        
        let backButton = UIBarButtonItem.back { [weak self] in self?.dismiss() }
        navigationItem.setLeftBarButton(backButton, animated: false)
        
        let menuButtonItem = UIBarButtonItem.menu { [weak self] in self?.router.showMenu() }
        navigationItem.setRightBarButton(menuButtonItem, animated: false)
        
        issueNameLabel.add(to: view).do {
            $0.topToSuperview(offset: Theme.nameLabelTopOffset)
            $0.leftToSuperview(offset: Theme.nameLabelSideOffset)
            $0.rightToSuperview()
            $0.height(Theme.issueNameLabelheight)
            
            $0.textAlignment = .left
            $0.font = Theme.issueNameFont
            $0.textColor = .darkCoal
            let issueName = (issue.title + " ").attributed.paint(with: .darkCoal)
            let issueNumber = String.Issues.issueNumber("\(issue.number)").attributed.paint(with: .textGray)
            $0.attributedText = issueName + issueNumber
        }
        
        issueStateView.add(to: view).do {
            $0.topToBottom(of: issueNameLabel)
            $0.left(to: issueNameLabel)
            $0.height(Theme.stateViewHeight)
        }
        
        descriptionLabel.add(to: view).do {
            $0.topToBottom(of: issueNameLabel)
            $0.leftToRight(of: issueStateView, offset: Theme.descriptionLabelLeftOffset)
            $0.height(Theme.descriptionHeight)
            
            $0.textAlignment = .left
            $0.numberOfLines = 0
            $0.font = Theme.descriptionFont
            $0.textColor = .textGray
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy"
            $0.text = String.Issues.issueOpened(issue.author, "\(formatter.string(from: issue.createdAt))")
        }
        
        let topDividerLine = UIView()
        topDividerLine.add(to: view).do {
            $0.edgesToSuperview(excluding: [.top, .bottom])
            $0.topToBottom(of: descriptionLabel, offset: Theme.separatorLineOffset)
            $0.height(1.0)
            $0.backgroundColor = .textGray
        }
        
        commentsCollection.collectionView.add(to: view).do {
            $0.edgesToSuperview(excluding: [.top, .bottom])
            $0.topToBottom(of: topDividerLine)
            $0.height(Theme.commentsCollectionHeight)
        }
    }
}

//MARK: - Theme
extension IssueDetailsVC {
    enum Theme {
        // Fonts
        static var issueNameFont: UIFont {
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
        static let descriptionFont: UIFont = .circular(style: .black, size: 13.0)
        
        // Sizes
        static let issueNameLabelheight: CGFloat = 25.0
        static let stateViewHeight: CGFloat = 30.0
        static let descriptionHeight: CGFloat = 33.0
        static let commentsCollectionHeight: CGFloat = 300.0
        
        // Offsets
        static let nameLabelSideOffset: CGFloat = 8.0
        static let nameLabelTopOffset: CGFloat = 13.0
        static let descriptionLabelLeftOffset: CGFloat = 5.0
        static let separatorLineOffset: CGFloat = 8.0
    }
}
