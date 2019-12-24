import UIKit

final class PullRequestsCollectionCell: UICollectionViewCell {
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    //MARK: - Actions
    private func setup() {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

//MARK: - Configure Cell
extension PullRequestsCollectionCell: ConfigurableCell {
    typealias CellData = PullRequest
    
    func configure(with data: PullRequest) {
        let pullRequest = data
        
    }
}

//MARK: - Theme
extension PullRequestsCollectionCell {
    enum Theme {
        
    }
}
