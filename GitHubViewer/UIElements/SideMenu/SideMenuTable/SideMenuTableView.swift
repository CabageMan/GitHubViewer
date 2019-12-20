import UIKit

final class SideMenuTableView: NSObject {
    
    enum MenuItem {
        case info(String)
        case firstFakeItem
        case secondFakeItem
        case thirdFakeItem
        case settings
        case logout
        
        var title: String {
            switch self {
            case .info: return ""
            case .firstFakeItem: return String.Fake.firstMenuItem
            case .secondFakeItem: return String.Fake.secondMenuItem
            case .thirdFakeItem: return String.Fake.thirdMenuItem
            case .settings: return String.SideMenu.settings
            case .logout: return String.SideMenu.logout
            }
        }
    }
    
    enum Section {
        case info(MenuItem)
        case screenMenu([MenuItem])
        case appMenu([MenuItem])
        
        var title: String {
            switch self {
            case .info: return String.SideMenu.signedInAs
            default: return ""
            }
        }
        
        var cellsCount: Int {
            switch self {
            case .info: return 1
            case .screenMenu(let screenMenuItems): return screenMenuItems.count
            case .appMenu(let appMenuItems): return appMenuItems.count
            }
        }
        
        var items: [MenuItem] {
            switch self {
            case .info: return []
            case .screenMenu(let screenMenuItems): return screenMenuItems
            case .appMenu(let appMenuItems): return appMenuItems
            }
        }
    }
    
    //MARK: - Public Properties
    let tableView = UITableView()
    var sections: [Section] = [] {
        didSet { tableView.reloadData() }
    }
    var menuItemSelected: (MenuItem) -> Void = { _ in }
    
    //MARK: - Initializers
    override init() {
        super.init()
        setup()
    }
    
    private func setup() {
        tableView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.registerHeader(TableViewSectionHeader.self)
            $0.registerCell(SideMenuCell.self)
            $0.tableFooterView = UIView()
            $0.alwaysBounceVertical = false
            $0.backgroundColor = .white
        }
    }
}

//MARK: - Table View Data Source Methods
extension SideMenuTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cellsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let cell: SideMenuCell = tableView.dequeueCell(for: indexPath)
        switch section {
        case .info(let infoItem):
            if case .info(let userLogin) = infoItem {
                cell.configure(title: userLogin, isSelectable: false)
            }
        case .screenMenu(let screenMenuItems):
            let screenMenuItem = screenMenuItems[indexPath.row]
            cell.configure(title: screenMenuItem.title)
        case .appMenu(let appMenuItems):
            let appMenuItem = appMenuItems[indexPath.row]
            cell.configure(title: appMenuItem.title)
        }
        return cell
    }
}

//MARK: - Table View Delegate Methods
extension SideMenuTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: TableViewSectionHeader =  tableView.dequeueReusableHeader()
        header.configure(title: sections[section].title)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Theme.cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Theme.headerHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        if !section.items.isEmpty {
            menuItemSelected(section.items[indexPath.row])
        }
    }
}

//MARK: - Theme
extension SideMenuTableView {
    enum Theme {
        // Sizes
        static var cellHeight: CGFloat = 70.0
        static var headerHeight: CGFloat = 40.0
    }
}
