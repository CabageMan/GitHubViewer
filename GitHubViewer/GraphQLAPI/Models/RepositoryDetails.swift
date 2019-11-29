import Foundation

struct RepositoryDetails {
    let repository: Repository
    var pushedAt: Date?
    var updatedAt: Date?
    let url: String
    let forkCount: Int
    let parent: RepositoryDetailsFragment.Parent?
    var assignableUsers: [User]
    
    init(repo: Repository, details: RepositoryDetailsFragment) {
        self.repository = repo
        if let pushedAtString = details.pushedAt {
            self.pushedAt = ISO8601DateFormatter().date(from: pushedAtString)
        }
        self.updatedAt = ISO8601DateFormatter().date(from: details.updatedAt)
        self.url = details.url
        self.forkCount = details.forkCount
        self.parent = details.parent
        if let assignableUsers = details.assignableUsers.nodes?.compactMap({ $0?.fragments.userFragment }).map({ User(user: $0) }) {
            self.assignableUsers = assignableUsers
        } else {
            self.assignableUsers = []
        }
    }
}
