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
    var commits: [Commit]
    let createdAt: Date
    var mergedAt: Date?
    var closedAt: Date?
    let mergedBy: String?
    
    init(request: PullRequestsListFragment) {
        self.id = request.id
        self.state = request.state
        self.author = request.author?.login ?? ""
        self.headRefName = request.headRefName
        self.baseRefName = request.baseRefName
        self.title = request.title
        self.number = request.number
        self.mergedBy = request.mergedBy?.login
        self.createdAt = ISO8601DateFormatter().date(from: request.createdAt) ?? Date()
        self.mergedAt = request.mergedAt != nil ? ISO8601DateFormatter().date(from: request.mergedAt!) : nil
        self.closedAt = request.closedAt != nil ? ISO8601DateFormatter().date(from: request.closedAt!) : nil
        self.assignees = (request.assignees.edges?.compactMap({ $0?.node }).map({ $0.login })) ?? []
        if let repository = request.baseRepository?.fragments.repositoriesListFragment {
            self.baseRepository = Repository(repo: repository)
        }
        
        
        let labels = request.labels?.edges?.compactMap({ $0?.node }).map({ PRLabel(name: $0.name, color: $0.color) }) ?? []
//        log("Labels: \(labels)")
        if let requestCommits = request.commits.edges {
            commits = requestCommits
                .compactMap({ $0?.node })
                .map({ Commit(commit: $0.commit.fragments.commitListFragment) })
        } else {
            commits = []
        }
    }
}
