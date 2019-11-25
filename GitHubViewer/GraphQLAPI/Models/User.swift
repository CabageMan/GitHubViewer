import Foundation

struct User {
    var name: String
    var login: String
    var repositoriesCount: Int
    var repositories: [Repository]
    
    init(user: OwnUserQuery.Data.Viewer) {
        self.name = user.name ?? ""
        self.login = user.login
        self.repositoriesCount = user.repositories.totalCount
        if let repos = user.repositories.nodes?.compactMap({ $0?.fragments.repositoriesListFragment }).map({ Repository(repo: $0) }) {
            self.repositories = repos
        } else {
            self.repositories = []
        }
    }
}
