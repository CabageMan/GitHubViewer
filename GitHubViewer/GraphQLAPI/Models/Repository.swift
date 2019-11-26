import Foundation

struct Repository {
    let id: String
    let name: String
    let createdAt: String
    var isPrivate: Bool
    var isFork: Bool
    var description: String?
    var primaryLanguage: RepositoriesListFragment.PrimaryLanguage?
    
    init(repo: RepositoriesListFragment) {
        self.id = repo.id
        self.name = repo.name
        self.createdAt = repo.createdAt
        self.isPrivate = repo.isPrivate
        self.isFork = repo.isFork
        self.description = repo.description
        self.primaryLanguage = repo.primaryLanguage
    }
}
