import UIKit

final class EmptyView: UIView {
    
    //MARK: -Initializers
    init(image: UIImage, text: String, offset: CGFloat) {
        super.init(frame: .zero)
        
        let imageView = UIImageView(image: image).add(to: self).then {
            $0.centerInSuperview(offset: CGPoint(0.0, offset))
            $0.widthToSuperview()
            $0.heightToWidth(of: self)
            
            $0.contentMode = .scaleAspectFit
        }
        
        UILabel().add(to: self).do {
            $0.edgesToSuperview(excluding: [.top, .bottom])
            $0.topToBottom(of: imageView, offset: -Theme.messageLabelTopOffset)
            
            $0.font = Theme.messageFont
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.textColor = .darkCoal
            $0.text = text
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

//MARK: - Templates
extension EmptyView {
    static func createEmptyRepositories(offset: CGFloat = 0.0) -> EmptyView {
        return EmptyView(image: #imageLiteral(resourceName: "OctoCatInClouds"), text: String.EmptyView.emptyRepositories, offset: offset)
    }
    
    static func createEmptyRepositoryDetails(offset: CGFloat = 0.0) -> EmptyView {
        return EmptyView(image: #imageLiteral(resourceName: "OctoCatInClouds"), text: String.EmptyView.emptyRepositoryDetails, offset: offset)
    }
    
    static func createEmptyPullRequests(offset: CGFloat = 0.0) -> EmptyView {
        return EmptyView(image: #imageLiteral(resourceName: "OctoCatInClouds"), text: String.EmptyView.emptyPullRequests, offset: offset)
    }
    
    static func createEmptyIssues(offset: CGFloat = 0.0) -> EmptyView {
        return EmptyView(image: #imageLiteral(resourceName: "OctoCatInClouds"), text: String.EmptyView.emptyIssues, offset: offset)
    }
    
    static func createEmptyProfile(offset: CGFloat = 0.0) -> EmptyView {
        return EmptyView(image: #imageLiteral(resourceName: "OctoCatInClouds"), text: String.EmptyView.emptyProfile, offset: offset)
    }
}

//MARK: - Theme
extension EmptyView {
    enum Theme {
        // Fonts
        static let messageFont: UIFont = .cf(style: .compactDisplayThin, size: 30.0)
        // Offsets
        static let messageLabelTopOffset: CGFloat = 15.0
    }
}

#warning("Learn why is map used here")
// init(image: UIImage? = nil, text: String? = nil) {
//    textLabel = text.map { _ in return UILabel() }
//    imageView = image.map(UIImageView.init(image: ))
//    super.init(frame: .zero)
//    setup()
//}
