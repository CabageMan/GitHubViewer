import Foundation

struct Issue {
    let id: String
    let number: Int
    let title: String
    let state: IssueState
    let author: String
    let assignees: [String?]
    
    init(issue: IssuesListFragment) {
        self.id = issue.id
        self.number = issue.number
        self.title = issue.title
        self.state = issue.state
        self.author = issue.author?.login ?? ""
        self.assignees = (issue.assignees.edges?.compactMap({ $0?.node }).map({ $0.login })) ?? []
        
//        let labels = issue.labels?.edges?.compactMap({ $0?.node }).map({ Label(name: $0.name, color: $0.color) }) ?? []
//        log("Labels: \(labels)")
    }
}
