import UIKit

public class PinToTopFlowLayout: UICollectionViewFlowLayout {
    
    private let header = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(row: 0, section: 0))
    private let headerHeight: CGFloat
    
    
    public init(headerHeight: CGFloat) {
        self.headerHeight = headerHeight
        super.init()
        header.frame.size = CGSize(width: UIScreen.main.bounds.width, height: headerHeight)
        header.zIndex = 10
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = self.collectionView else { return nil }
        
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        
        header.frame.origin.y = collectionView.contentOffset.y
        
        var newAttributes = layoutAttributes?.filter {
            guard let elementKind = $0.representedElementKind else { return true }
            return (elementKind == UICollectionView.elementKindSectionHeader && $0.indexPath.section == 0) == false
        }
        newAttributes?.append(header)
        
        return newAttributes
    }
}
