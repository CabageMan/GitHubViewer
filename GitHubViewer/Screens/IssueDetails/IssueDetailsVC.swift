import UIKit

final class IssueDetailsVC: UIViewController {
    
    private let viewModel: IssueDetailsVM
    private var tabBarViewController: TabBarViewController? {
        guard let coordinator: TabBarCoordinator = viewModel.router.currentCoordinator?.findParent() else { return nil }
        return coordinator.tabBarViewController
    }
    private let issueNameLabel = UILabel()
    private let issueStateView: StateView
    private let descriptionLabel = UILabel()
    private let commentsCollection = GitHubViewerCollection<IssueCommentCell>(mode: .issueComments)
    private let bottomContainer = UIView()
    private let newCommentContainer = UIView()
    private let newCommentTextView = UITextView()
    private let ownerAvatar = ImageContentView()
    private let commentButton = Buttons.roundedButton(title: String.Issues.comment)
    
    private var newCommentContainerHeightConstraint: NSLayoutConstraint!
    private var newCommentContainerBottomConstraint: NSLayoutConstraint!
    
    //MARK: - Life Cycle
    init(router: GithubViewerRouter, issue: Issue) {
        self.viewModel = IssueDetailsVM(router: router, issue: issue)
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
        setupViewModel()
        commentsCollection.items = viewModel.issue.comments
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarViewController?.hideTabBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tabBarViewController?.showTabBar()
    }
    
    //MARK: - Actions
    private func setupUI() {
        view.backgroundColor = .mainBackground
        
        let backButton = UIBarButtonItem.back { [weak self] in self?.dismiss() }
        navigationItem.setLeftBarButton(backButton, animated: false)
        
        let menuButtonItem = UIBarButtonItem.menu { [weak self] in self?.viewModel.router.showMenu() }
        navigationItem.setRightBarButton(menuButtonItem, animated: false)
        
        issueNameLabel.add(to: view).do {
            $0.topToSuperview(offset: Theme.nameLabelTopOffset)
            $0.leftToSuperview(offset: Theme.nameLabelSideOffset)
            $0.rightToSuperview()
            $0.height(Theme.issueNameLabelheight)
            
            $0.textAlignment = .left
            $0.font = Theme.issueNameFont
            $0.textColor = .darkCoal
            let issueName = (viewModel.issue.title + " ").attributed.paint(with: .darkCoal)
            let issueNumber = String.Issues.issueNumber("\(viewModel.issue.number)").attributed.paint(with: .textGray)
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
            $0.text = String.Issues.issueOpened(viewModel.issue.author, "\(formatter.string(from: viewModel.issue.createdAt))")
        }
        
        let topDividerLine = UIView().add(to: view).then {
            $0.edgesToSuperview(excluding: [.top, .bottom])
            $0.topToBottom(of: descriptionLabel, offset: Theme.separatorLineOffset)
            $0.height(1.0)
            $0.backgroundColor = .textGray
        }
        
        bottomContainer.add(to: view).do {
            $0.edgesToSuperview(excluding: [.top, .bottom])
            newCommentContainerBottomConstraint = $0.bottomToSuperview(offset: -.safeBottom)
            newCommentContainerHeightConstraint = $0.height(Theme.newCommentContainerHeight)
            $0.backgroundColor = .clear
        }
        
        commentsCollection.collectionView.add(to: view).do {
            $0.edgesToSuperview(excluding: [.top, .bottom])
            $0.topToBottom(of: topDividerLine)
            $0.bottomToTop(of: bottomContainer)
        }
        
        UIView().add(to: bottomContainer).do {
            $0.edgesToSuperview(excluding: .bottom)
            $0.height(1.0)
            $0.backgroundColor = .textGray
        }
        
        ownerAvatar.add(to: bottomContainer).do {
            $0.leftToSuperview(offset: Theme.avatarLeftOffset)
            $0.topToSuperview(offset: Theme.avatarTopOffset)
            $0.size(Theme.avatarSize)
            if let url = Global.apiClient.ownUser?.avatarURL, let avatarUrl = URL(string: url) {
                $0.configure(url: avatarUrl, diameter: Theme.avatarSize.width, animated: true)
            } else {
                $0.configure(image: Theme.avatarPlaceHolder, animated: true)
            }
        }
        
        newCommentContainer.add(to: bottomContainer).do {
            $0.edgesToSuperview(excluding: .left, insets: UIEdgeInsets(value: Theme.newCommentContainerOffset))
            $0.leftToRight(of: ownerAvatar, offset: Theme.newCommentContainerOffset)
            $0.backgroundColor = .white
            $0.layer.borderColor = Theme.containerBorderColor.cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.cornerRadius = 3.0
        }
        
        commentButton.add(to: newCommentContainer).do {
            $0.rightToSuperview(offset: -Theme.buttonOffset)
            $0.bottomToSuperview(offset: -Theme.buttonOffset)
            $0.height(Theme.buttonHeight)
            
            $0.addTarget(for: .touchUpInside) { [weak self] in self?.viewModel.sendComment() }
        }
        
        Buttons.iconButton(icon: #imageLiteral(resourceName: "openIssue"), title: String.Issues.closeIssue).add(to: newCommentContainer).do {
            $0.rightToLeft(of: commentButton, offset: -Theme.buttonOffset)
            $0.bottom(to: commentButton)
            $0.height(Theme.buttonHeight)
            
            $0.addTarget(for: .touchUpInside) { [weak self] in self?.viewModel.closeIssue() }
        }
        
        newCommentTextView.add(to: newCommentContainer).do {
            $0.edgesToSuperview(excluding: .bottom, insets: UIEdgeInsets(value: Theme.commentTextViewOffset))
            $0.bottomToTop(of: commentButton, offset: -Theme.commentTextViewOffset)
            $0.backgroundColor = Theme.newCommentBackGround
            $0.layer.borderColor = Theme.textFieldBorderColor.cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.cornerRadius = 3.0
        }
    }
    
    private func setupViewModel() {
        viewModel.issueClosed = { result in
            guard result else { return }
            Global.showComingSoon()
        }
        viewModel.commentSended = { result in
            guard result else { return }
            Global.showComingSoon()
        }
    }
}

//MARK: - Theme
extension IssueDetailsVC {
    enum Theme {
        // Images
        static let avatarPlaceHolder: UIImage = #imageLiteral(resourceName: "AvatarPlaceholder")
        
        // Colors
        static let buttonIconColor: UIColor = #colorLiteral(red: 0.7960784314, green: 0.137254902, blue: 0.1921568627, alpha: 1) // #CB2331
        static let newCommentBackGround: UIColor = #colorLiteral(red: 0.9803921569, green: 0.9843137255, blue: 0.9882352941, alpha: 1) // #FAFBFC
        static let textFieldBorderColor: UIColor = #colorLiteral(red: 0.8196078431, green: 0.8352941176, blue: 0.8549019608, alpha: 1) // #D1D5DA
        static let containerBorderColor: UIColor = #colorLiteral(red: 0.8823529412, green: 0.8941176471, blue: 0.9098039216, alpha: 1) // #E1E4E8
        
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
        static let newCommentContainerHeight: CGFloat = 200.0
        static let avatarSize = CGSize(30.0)
        static let buttonsheight: CGFloat = 40.0
        
        // Offsets
        static let nameLabelSideOffset: CGFloat = 8.0
        static let nameLabelTopOffset: CGFloat = 13.0
        static let descriptionLabelLeftOffset: CGFloat = 5.0
        static let separatorLineOffset: CGFloat = 8.0
        static let avatarTopOffset: CGFloat = 10.0
        static let avatarLeftOffset: CGFloat = 5.0
        static let newCommentContainerOffset: CGFloat = 10.0
        static let commentTextViewOffset: CGFloat = 10.0
        static let buttonOffset: CGFloat = 10.0
        static let buttonHeight: CGFloat = 35.0
    }
}

//TODO: - Need To do -
// Add logic to add comments and close issues.
// Make comments collection cells auto resizable.
// Fix Bezier triangles drawing in comments collection cell. Add this solution to newCommentContainer.
// Handle keyboard appearing.
// Resize new comment text view.
// Validate new comment text to block/unblock comment button
