import UIKit
import Parchment

final class GitHabViewerPagingController: NSObject {
    
    let pagingController = PagingViewController<PagingIndexItem>()
    let viewControllers: [UIViewController]
    var currentPageIndex: Int
    
    private var defaultItemWidth: CGFloat {
        return UIScreen.main.bounds.width / CGFloat(viewControllers.count) - Theme.itemsSpacing * 2
    }
    
    var didScroll: (Int) -> Void = { _ in }

    //MARK: - Initializers
    init(viewControllers: [UIViewController], currentPage: Int) {
        self.viewControllers = viewControllers
        self.currentPageIndex = currentPage
        super.init()
        setupUI()
    }
    
    private func setupUI() {
        pagingController.do {
            $0.menuItemSource = .class(type: PagingTitleCell.self)
            $0.menuHorizontalAlignment = .center
            $0.menuItemSize = .sizeToFit(minWidth: defaultItemWidth, height: Theme.menuHeight)
            
            $0.font = Theme.font
            $0.selectedFont = Theme.selectedFont
            $0.textColor = .textGray
            $0.selectedTextColor = .darkCoal
            $0.borderOptions = .hidden
            $0.indicatorOptions = .hidden
            $0.menuBackgroundColor = .mainBackground
            $0.dataSource = self
            $0.delegate = self
            
            $0.loadViewIfNeeded()
            $0.select(index: currentPageIndex, animated: true)
        }
    }
}

//MARK: - Paging View Controller Datasource Methods
extension GitHabViewerPagingController: PagingViewControllerDataSource {
    func numberOfViewControllers<T>(in pagingViewController: PagingViewController<T>) -> Int where T : PagingItem, T : Comparable, T : Hashable {
        return viewControllers.count
    }
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, viewControllerForIndex index: Int) -> UIViewController where T : PagingItem, T : Comparable, T : Hashable {
        return viewControllers[index]
    }
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemForIndex index: Int) -> T where T : PagingItem, T : Comparable, T : Hashable {
        return PagingIndexItem(index: index, title: viewControllers[index].title ?? "") as! T
    }
}

//MARK: - Paging View Controller Delegate Methods
extension GitHabViewerPagingController: PagingViewControllerDelegate {
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, didScrollToItem pagingItem: T, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) where T : PagingItem, T : Comparable, T : Hashable {
        guard transitionSuccessful,
              let index = viewControllers.firstIndex(of: destinationViewController)
        else { return }
        currentPageIndex = index
        didScroll(index)
    }
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, widthForPagingItem pagingItem: T, isSelected: Bool) -> CGFloat? where T : PagingItem, T : Comparable, T : Hashable {
        guard let item = pagingItem as? PagingIndexItem else { return defaultItemWidth }

        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: pagingViewController.menuItemSize.height)
        let attributes = [NSAttributedString.Key.font: pagingViewController.font]
        
        let rect = item.title.boundingRect(with: size,
          options: .usesLineFragmentOrigin,
          attributes: attributes,
          context: nil)

        let width = ceil(rect.width) + Theme.itemsInsets.left + Theme.itemsInsets.right
        
        if isSelected {
          return width * 1.5
        } else {
          return width
        }
    }
}

//MARK: - Theme
extension GitHabViewerPagingController {
    enum Theme {
        // Fonts
        static let selectedFont: UIFont = .circular(style: .bold, size: 14.0)
        static let font: UIFont = .circular(style: .medium, size: 14.0)
        
        // Sizes
        static let menuHeight: CGFloat = 30.0
        
        // Offsets
        static let itemsInsets = UIEdgeInsets(top: 0, left: 20.0, bottom: 0, right: 20.0)
        static var itemsSpacing: CGFloat {
            switch Device.realDiagonal {
            case Device.iPhone5.diagonal: return 7.0
            case Device.iPhone6.diagonal: return 14.0
            default: return 16.0
            }
        }
    }
}

//MARK: - Page Mode
enum PageMode: Int {
    case created = 0
    case assigned
    case mentioned
    case reviewRequests
    
    static var all: [PageMode] {
        return [.created, .assigned, .mentioned, .reviewRequests]
    }
    
    static var issueMode: [PageMode] {
        return [.created, .assigned, .mentioned]
    }
    
    var title: String {
        switch self {
        case .created: return String.PagesMode.created
        case .assigned: return String.PagesMode.assigned
        case .mentioned: return String.PagesMode.mentioned
        case .reviewRequests: return String.PagesMode.reviewRequests
        }
    }
}

