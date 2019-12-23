import UIKit

final class GitHubViewerCollection: NSObject {
    
    enum Mode {
        case repositories
        case pullRequests
    }
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout().then {
            $0.minimumLineSpacing = 0.0
            $0.minimumInteritemSpacing = 0.0
            $0.scrollDirection = .vertical
        }
        return UICollectionView(layout: layout)
    }()
    private var activityFooter: CollectionActivityFooterView?
    
    var items: [Repository] = [] {
        didSet {
            collectionView.do {
                $0.backgroundView = items.isEmpty ? EmptyView.createEmptyRepositories(offset: -Theme.emptyViewOffset) : nil
                $0.reloadData()
            }
        }
    }
    
    var nextDataIsLoading: Bool = false {
        didSet {
            nextDataIsLoading ? activityFooter?.startAnimating() : activityFooter?.stopAnimating()
        }
    }
    
    var onCellTap: (Repository) -> Void = { _ in }
    var getNextData: () -> Void = { }
    
    //MARK: - Initializers
    override init() {
        super.init()
        
        collectionView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.registerCell(RepositoriesCollectionCell.self)
            $0.registerFooter(CollectionActivityFooterView.self)
            $0.alwaysBounceVertical = true
            $0.backgroundColor = .clear
        }
    }
}

//MARK: - Collection Data Source Methods
extension GitHubViewerCollection: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RepositoriesCollectionCell = collectionView.dequeueCell(for: indexPath)
        cell.configure(with: items[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footer: CollectionActivityFooterView = collectionView.dequeueFooter(for: indexPath)
            activityFooter = footer
            return footer
        default:
            fatalError("Unsupported reusable view kind")
        }
    }
}

//MARK: - Collection Delegate Methods
extension GitHubViewerCollection: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: Theme.cellHeight)
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
}

//MARK: - Scroll View Delegate
extension GitHubViewerCollection {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if !nextDataIsLoading && collectionView.isEndOfScroll {
            getNextData()
        }
    }
}

//MARK: - Theme
extension GitHubViewerCollection {
    enum Theme {
        // Sizes
        static let cellHeight: CGFloat = 74.0
        
        // Offsets
        static let cellSideOffset: CGFloat = 36.0
        static let collectionViewInsets: UIEdgeInsets = UIEdgeInsets(top: 15.0, left: 0, bottom: 15.0, right: 0)
        static let emptyViewOffset: CGFloat = 50.0
    }
}
