import Foundation

struct RepositoryDetails {
    let repository: Repository
    var pushedAt: String?
    var updatedAt: String
    let resourcePath: String
    let url: String
    let forkCount: Int
    let parent: RepositoryDetailsFragment.Parent?
    
    init(repo: Repository, details: RepositoryDetailsFragment) {
        self.repository = repo
        self.pushedAt = details.pushedAt
        self.updatedAt = details.updatedAt
        self.resourcePath = details.resourcePath
        self.url = details.url
        self.forkCount = details.forkCount
        self.parent = details.parent
    }
}
