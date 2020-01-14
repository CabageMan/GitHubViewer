import Foundation

struct Issue {
    let id: String
    let number: Int
    let title: String
    let state: IssueState
    let author: String
    let assignees: [String?]
    let repository: Repository
    let createdAt: Date
    let closedAt: Date?
    let updatedAt: Date
    let comments: [IssueComment]
    
    init(issue: IssuesListFragment) {
        self.id = issue.id
        self.number = issue.number
        self.title = issue.title
        self.state = issue.state
        self.author = issue.author?.login ?? ""
        self.assignees = (issue.assignees.edges?.compactMap({ $0?.node }).map({ $0.login })) ?? []
        self.repository = Repository(repo: issue.repository.fragments.repositoriesListFragment)
        self.createdAt = ISO8601DateFormatter().date(from: issue.createdAt) ?? Date()
        self.closedAt = issue.closedAt != nil ? ISO8601DateFormatter().date(from: issue.closedAt!) : nil
        self.updatedAt = ISO8601DateFormatter().date(from: issue.updatedAt) ?? Date()
        self.comments = issue.comments.edges?.compactMap({ $0?.node }).map({ IssueComment(comment: $0.fragments.issueCommentFragment) }) ?? []
//        let labels = issue.labels?.edges?.compactMap({ $0?.node }).map({ Label(name: $0.name, color: $0.color) }) ?? []
//        log("Labels: \(labels)")
    }
}
