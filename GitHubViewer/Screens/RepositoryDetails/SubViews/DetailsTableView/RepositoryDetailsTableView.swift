import UIKit

final class RepositoryDetailsTableView: NSObject {
    
    struct InfoItem {
        let title: String
        let details: String
    }

    struct LinkItem {
        let title: String
        let url: String
        let action: (String) -> Void
    }

    enum Section {
        case info([InfoItem])
        case parent(RepositoryDetailsFragment.Parent)
        case links([LinkItem])
        case assignableUsers([User])
        
        var title: String {
            switch self {
            case .info: return String.Repos.repositoryInfo
            case .parent: return String.Repos.parent
            case .links: return String.Repos.url
            case .assignableUsers: return String.Repos.assignableUsers
            }
        }
        
        var cellsCount: Int {
            switch self {
            case .info(let infoItems): return infoItems.count
            case .links(let linkItems): return linkItems.count
            case .assignableUsers(let users): return users.count
            default: return 1
            }
        }
    }
    
    //MARK: - Public Properties
    let tableView = UITableView()
    var sections: [Section] = [] {
        didSet { tableView.reloadData() }
    }
    
    //MARK: - Initializers
    override init() {
        super.init()
        setup()
    }
    
    private func setup() {
        tableView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.registerHeader(RepositoryDetailsTVSectionHeader.self)
            $0.registerCell(RepositoryDetailsTVInfoCell.self)
            $0.registerCell(RepositoryDetailsTVLinkCell.self)
            $0.registerCell(RepositoryDetailsTVUserCell.self)
            
            $0.backgroundColor = .white
        }
    }
}

//MARK: - Table View Data Source Methods
extension RepositoryDetailsTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        log("Namber Of Rows: \(sections[section].cellsCount)")
        return sections[section].cellsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        switch section {
        case .info(let infoItems):
            let infoItem = infoItems[indexPath.row]
            let cell: RepositoryDetailsTVInfoCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: infoItem.title, info: infoItem.details)
            return cell
        case .parent(let parent):
            let cell: RepositoryDetailsTVInfoCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: "Title", info: parent.name)
            return cell
        case .links(let linkItems):
            let linkItem = linkItems[indexPath.row]
            let cell: RepositoryDetailsTVLinkCell = tableView.dequeueCell(for: indexPath)
            cell.configure(link: linkItem.url)
            return cell
        case .assignableUsers(let users):
            let cell: RepositoryDetailsTVUserCell = tableView.dequeueCell(for: indexPath)
            cell.configure(user: users[indexPath.row])
            return cell
        }
    }
}

//MARK: - Table View Delegate Methods
extension RepositoryDetailsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: RepositoryDetailsTVSectionHeader =  tableView.dequeueReusableHeader()
        header.configure(title: sections[section].title)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Theme.cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Theme.headerHeight
    }
}

//MARK: - Theme
extension RepositoryDetailsTableView {
    enum Theme {
        // Sizes
        static var cellHeight: CGFloat = 70.0
        static var headerHeight: CGFloat = 40.0
    }
}
