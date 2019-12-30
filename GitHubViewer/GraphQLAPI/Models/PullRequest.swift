import Foundation

struct PullRequest {
    struct PRLabel {
        var name: String
        var color: String
    }
    
    let id: String
    let state: PullRequestState
    let author: String
    let headRefName: String
    let baseRefName: String
    let title: String
    let number: Int
    var baseRepository: Repository?
    var assignees: [String?]
//    var commits: [Commit]
    let createdAt: Date
    var mergedAt: Date?
    var closedAt: Date?
    
    init(request: PullRequestsListFragment) {
        self.id = request.id
        self.state = request.state
        self.author = request.author?.login ?? ""
        self.headRefName = request.headRefName
        self.baseRefName = request.baseRefName
        self.title = request.title
        self.number = request.number
        self.createdAt = ISO8601DateFormatter().date(from: request.createdAt) ?? Date()
        self.mergedAt = request.mergedAt != nil ? ISO8601DateFormatter().date(from: request.mergedAt!) : nil
        self.closedAt = request.closedAt != nil ? ISO8601DateFormatter().date(from: request.closedAt!) : nil
        self.assignees = (request.assignees.edges?.compactMap({ $0?.node }).map({ $0.login })) ?? []
        if let repository = request.baseRepository?.fragments.repositoriesListFragment {
            self.baseRepository = Repository(repo: repository)
        }
        
        
        let labels = request.labels?.edges?.compactMap({ $0?.node }).map({ PRLabel(name: $0.name, color: $0.color) }) ?? []
//        log("Labels: \(labels)")
        let commits = request.commits.edges?
            .compactMap({ $0?.node })
            .map({ $0.commit.fragments.commitListFragment })
        commits?.forEach { log("Commits: \($0)") }
        
    }
}
