import Foundation

struct Repository {
    let id: String
    let name: String
    let createdAt: Date
    let resourcePath: String
    var isPrivate: Bool
    let isFork: Bool
    let forkCount: Int
    var description: String?
    var primaryLanguage: RepositoriesListFragment.PrimaryLanguage?
    let stargazersCount: Int
    
    init(repo: RepositoriesListFragment) {
        self.id = repo.id
        self.name = repo.name
        self.createdAt = ISO8601DateFormatter().date(from: repo.createdAt) ?? Date()
        self.resourcePath = String(repo.resourcePath.dropFirst())
        self.isPrivate = repo.isPrivate
        self.isFork = repo.isFork
        self.forkCount = repo.forkCount
        self.description = repo.description
        self.primaryLanguage = repo.primaryLanguage
        self.stargazersCount = repo.stargazers.totalCount
    }
}
