import Foundation

struct Issue {
    let id: String
    let number: Int
    let title: String
    
    init(issue: IssuesListFragment) {
        self.id = issue.id
        self.number = issue.number
        self.title = issue.title
        
        let labels = issue.labels?.edges?.compactMap({ $0?.node }).map({ Label(name: $0.name, color: $0.color) }) ?? []
        log("Labels: \(labels)")
    }
}
