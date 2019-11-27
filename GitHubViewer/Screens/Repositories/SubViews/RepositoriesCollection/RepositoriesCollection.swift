import UIKit

final class RepositoriesCollection: NSObject {
    
    var collectionView: UICollectionView = {
        let layout = PinToTopFlowLayout(headerHeight: Theme.headerHeight).then {
            $0.minimumLineSpacing = 15.0
            $0.minimumInteritemSpacing = 0
            $0.scrollDirection = .vertical
        }
        return UICollectionView(layout: layout)
    }()
    var headerView: RepositoriesCollectionHeader?
    
    var items: [Repository] = [] {
        didSet { collectionView.reloadData() }
    }
    
    var onCellTap: (Repository) -> Void = { _ in }
    
    //MARK: - Initializers
    override init() {
        super.init()
        
        collectionView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.registerCell(RepositoriesCollectionCell.self)
            $0.registerHeader(RepositoriesCollectionHeader.self)
            $0.alwaysBounceVertical = true
            $0.backgroundColor = .clear
            $0.scrollIndicatorInsets.top = Theme.headerHeight
        }
    }
}

//MARK: - Collection Data Source Methods
extension RepositoriesCollection: UICollectionViewDataSource {
    
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
        case UICollectionView.elementKindSectionHeader:
            let header: RepositoriesCollectionHeader = collectionView.dequeueHeader(for: indexPath)
            headerView = header
            return header
        default:
            fatalError("Unsupported reusable view kind")
        }
    }
}

//MARK: - Collection Delegate Methods
extension RepositoriesCollection: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - Theme.cellSideOffset, height: Theme.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: Theme.headerHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Theme.collectionViewInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onCellTap(items[indexPath.row])
    }
}

//MARK: - UIScrollView Delegate Methods
//extension RepositoriesCollection {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        log("Scroll Position: \(scrollView.contentOffset.y)")
//    }
//}

//MARK: - Theme
extension RepositoriesCollection {
    enum Theme {
        // Sizes
        static let cellHeight: CGFloat = 97.0
        static let headerHeight: CGFloat = 105.0
        
        // Offsets
        static let cellSideOffset: CGFloat = 36.0
        static let collectionViewInsets: UIEdgeInsets = UIEdgeInsets(top: 15.0, left: 0, bottom: 15.0, right: 0)
    }
}
