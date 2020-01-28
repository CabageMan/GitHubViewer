import UIKit

final class GitHubViewerCollection<T: UICollectionViewCell & ConfigurableCell>: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout().then {
            $0.minimumLineSpacing = 0.0
            $0.minimumInteritemSpacing = 0.0
            $0.scrollDirection = .vertical
        }
        return UICollectionView(layout: layout)
    }()
    var selectorHeader: CollectionSelectorHeader?
    private var activityFooter: CollectionActivityFooterView?
    
    private let mode: Mode
    
    var items: [T.CellData] = [] {
        didSet {
            collectionView.do {
                $0.backgroundView = items.isEmpty ? mode.backGround : nil
                $0.reloadData()
            }
        }
    }
    
    var nextDataIsLoading: Bool = false {
        didSet {
            nextDataIsLoading ? activityFooter?.startAnimating() : activityFooter?.stopAnimating()
        }
    }
    
    var onCellTap: (T.CellData) -> Void = { _ in }
    var getNextData: () -> Void = { }
    var onHeaderSelectorChanged: () -> Void = { }
    
    //MARK: - Initializers
    init(mode: Mode) {
        self.mode = mode
        super.init()
        
        collectionView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.registerCell(T.self)
            switch mode {
            case .pullRequests, .issues: $0.registerHeader(CollectionSelectorHeader.self)
            default: break
            }
            $0.registerFooter(CollectionActivityFooterView.self)
            $0.alwaysBounceVertical = true
            $0.backgroundColor = .clear
        }
    }
    
    //MARK: - Collection Data Source Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: T = collectionView.dequeueCell(for: indexPath)
        cell.configure(with: items[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            switch mode {
            case .pullRequests, .issues:
                let header: CollectionSelectorHeader = collectionView.dequeueHeader(for: indexPath)
                if case .issues = mode {
                    header.configure(mode: .issueOpen)
                }
                header.onSelectorChanged = onHeaderSelectorChanged
                selectorHeader = header
                return header
            case .repositories, .commits, .issueComments:
                return UICollectionReusableView()
            }
        case UICollectionView.elementKindSectionFooter:
            let footer: CollectionActivityFooterView = collectionView.dequeueFooter(for: indexPath)
            activityFooter = footer
            return footer
        default:
            fatalError("Unsupported reusable view kind")
        }
    }
    
    //MARK: - Collection Delegate Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: mode.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch mode {
        case .pullRequests, .issues:
            return CGSize(width: UIScreen.main.bounds.width, height: CollectionSelectorHeader.Theme.headerHeight)
        case .repositories, .commits, .issueComments:
            return CGSize.zero
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: CollectionActivityFooterView.Theme.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Theme.collectionViewInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onCellTap(items[indexPath.row])
    }
    
    //MARK: - Scroll View Delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if !nextDataIsLoading && collectionView.isEndOfScroll {
            getNextData()
        }
    }
}

//MARK: - Mode
extension GitHubViewerCollection {
    enum Mode {
        case repositories
        case pullRequests
        case commits
        case issues
        case issueComments
        
        var backGround: UIView {
            switch self {
            case .repositories:
                return EmptyView.createEmptyRepositories(offset: -Theme.emptyViewOffset)
            case .pullRequests:
                return EmptyView.createEmptyPullRequests(offset: -Theme.emptyViewOffset)
            case .commits:
                return EmptyView.createEmptyCommits(offset: -Theme.emptyViewOffset)
            case .issues:
                return EmptyView.createEmptyIssues(offset: -Theme.emptyViewOffset)
            case .issueComments:
                return EmptyView.createEmptyIssueComments(offset: -Theme.emptyViewOffset)
            }
        }
        
        var cellHeight: CGFloat {
            switch self {
            case .repositories:
                return Theme.repositoryCellHeight
            case .pullRequests:
                return Theme.pullRequestCellHeight
            case .commits:
                return Theme.commitCellHeight
            case .issues:
                return Theme.issueCellHeight
            case .issueComments:
                return Theme.issueCommentHeight
            }
        }
    }
}

//MARK: - Theme
fileprivate enum Theme {
    // Sizes
    static let repositoryCellHeight: CGFloat = 74.0
    static let pullRequestCellHeight: CGFloat = 80.0
    static let commitCellHeight: CGFloat = 50.0
    static let issueCellHeight: CGFloat = 80.0
    static let issueCommentHeight: CGFloat = 90.0
    
    // Offsets
    static let cellSideOffset: CGFloat = 36.0
    static let collectionViewInsets: UIEdgeInsets = UIEdgeInsets(top: 15.0, left: 0, bottom: 15.0, right: 0)
    static let emptyViewOffset: CGFloat = 50.0
}
