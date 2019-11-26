import UIKit

final class RepositoriesCollection: NSObject {
    
    let collectionView = UICollectionView(layout: UICollectionViewFlowLayout())
    
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
            $0.registerCell(RepositoryCollectionCell.self)
            $0.backgroundColor = .clear
        }
    }
}

//MARK: - Collection Data Source Methods
extension RepositoriesCollection: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RepositoryCollectionCell = collectionView.dequeueCell(for: indexPath)
        cell.configure(with: items[indexPath.row])
        
        return cell
    }
}

//MARK: - Collection Delegate Methods
extension RepositoriesCollection: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - Theme.cellSideOffset, height: Theme.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onCellTap(items[indexPath.row])
    }
}

//MARK: - UIScrollView Delegate Methods
extension RepositoriesCollection {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        log("Scroll Position: \(scrollView.contentOffset.y)")
    }
}

//MARK: - Theme
extension RepositoriesCollection {
    enum Theme {
        // Sizes
        static let cellHeight: CGFloat = 97.0
        
        // Offsets
        static let cellSideOffset: CGFloat = 36.0
    }
}
