import Foundation

struct RepositoryDetails {
    let repository: Repository
    var pushedAt: Date?
    var updatedAt: Date?
    let resourcePath: String
    let url: String
    let forkCount: Int
    let parent: RepositoryDetailsFragment.Parent?
    
    init(repo: Repository, details: RepositoryDetailsFragment) {
        self.repository = repo
        if let pushedAtString = details.pushedAt {
            self.pushedAt = ISO8601DateFormatter().date(from: pushedAtString)
        }
        self.updatedAt = ISO8601DateFormatter().date(from: details.updatedAt)
        self.resourcePath = details.resourcePath
        self.url = details.url
        self.forkCount = details.forkCount
        self.parent = details.parent
    }
}
