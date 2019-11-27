import Foundation

struct Repository {
    let id: String
    let name: String
    let createdAt: Date?
    var isPrivate: Bool
    let isFork: Bool
    var description: String?
    var primaryLanguage: RepositoriesListFragment.PrimaryLanguage?
    
    init(repo: RepositoriesListFragment) {
        self.id = repo.id
        self.name = repo.name
        self.createdAt = ISO8601DateFormatter().date(from: repo.createdAt)
        self.isPrivate = repo.isPrivate
        self.isFork = repo.isFork
        self.description = repo.description
        self.primaryLanguage = repo.primaryLanguage
    }
}
