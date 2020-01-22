import Foundation

final class IssueDetailsVM {
    
    let router: GithubViewerRouter
    
    let issue: Issue
    
    var commentSended: (Bool) -> Void = { _ in }
    var issueClosed: (Bool) -> Void = { _ in }
    
    //MARK: -Initializers
    init(router: GithubViewerRouter, issue: Issue) {
        self.router = router
        self.issue = issue
    }
    
    //MARK: -Actions
    func closeIssue() {
        issueClosed(true)
    }
    
    func sendComment(_ comment: String) {
        commentSended(true)
    }
}
