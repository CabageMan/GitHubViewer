import Foundation

struct User {
    var name: String
    var login: String
    var avatarURL: String
    var repositoriesCount: Int
    var repositories: [Repository]
    
    init(user: UserFragment) {
        self.name = user.name ?? ""
        self.login = user.login
        self.avatarURL = user.avatarUrl
        self.repositoriesCount = user.repositories.totalCount
        if let repos = user.repositories.nodes?.compactMap({ $0?.fragments.repositoriesListFragment }).map({ Repository(repo: $0) }) {
            self.repositories = repos
        } else {
            self.repositories = []
        }
    }
}
