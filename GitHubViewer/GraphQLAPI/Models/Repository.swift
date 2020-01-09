import Foundation

struct Repository {
    let id: String
    let name: String
    let createdAt: Date
    let resourcePath: String
    var isPrivate: Bool
    let isFork: Bool
    var description: String?
    var primaryLanguage: RepositoriesListFragment.PrimaryLanguage?
    
    init(repo: RepositoriesListFragment) {
        self.id = repo.id
        self.name = repo.name
        self.createdAt = ISO8601DateFormatter().date(from: repo.createdAt) ?? Date()
        self.resourcePath = String(repo.resourcePath.dropFirst())
        self.isPrivate = repo.isPrivate
        self.isFork = repo.isFork
        self.description = repo.description
        self.primaryLanguage = repo.primaryLanguage
    }
}
