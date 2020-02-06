import Foundation

final class IssueDetailsVM {
    
    let router: GithubViewerRouter
    
    var issue: Issue
    
    var issueUpdated: () -> Void = { }
    
    //MARK: -Initializers
    init(router: GithubViewerRouter, issue: Issue) {
        self.router = router
        self.issue = issue
    }
    
    //MARK: -Actions
    func closeOpenIssue() {
        switch issue.state {
        case .open: closeIssue()
        case .closed: reopenIssue()
        default: break
        }
    }
    
    func sendComment(_ comment: String) {
        Spinner.start()
        let commentInput = AddCommentInput(subjectId: issue.id, body: comment)
        GitHubViewerApollo.shared.client.perform(mutation: AddCommentToIssueMutation(issueComment: commentInput)) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                guard let updatedIssue = result.data?.addComment?.commentEdge?.node?.issue.fragments.issuesListFragment else {
                    Spinner.stop()
                    log("Failed to send comment")
                    return
                }
                self.issue = Issue(issue: updatedIssue)
                self.issueUpdated()
                Spinner.stop()
            case .failure(let error):
                Spinner.stop()
                log("Failed to send comment \(error.localizedDescription)")
            }
        }
    }
    
    private func closeIssue() {
        Spinner.start()
        let issueInput = CloseIssueInput(issueId: issue.id)
        GitHubViewerApollo.shared.client.perform(mutation: CloseIssueMutation(issueInput: issueInput)) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                guard let updatedIssue = result.data?.closeIssue?.issue?.fragments.issuesListFragment else {
                    Spinner.stop()
                    log("Failed to close issue")
                    return
                }
                self.issue = Issue(issue: updatedIssue)
                self.issueUpdated()
                Spinner.stop()
            case .failure(let error):
                Spinner.stop()
                log("Failed to close issue \(error.localizedDescription)")
            }
        }
    }
    
    private func reopenIssue() {
        Spinner.start()
        let issueInput = ReopenIssueInput(issueId: issue.id)
        GitHubViewerApollo.shared.client.perform(mutation: ReopenIssueMutation(issueInput: issueInput)) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                guard let updatedIssue = result.data?.reopenIssue?.issue?.fragments.issuesListFragment else {
                    Spinner.stop()
                    log("Failed to load issue")
                    return
                }
                self.issue = Issue(issue: updatedIssue)
                self.issueUpdated()
                Spinner.stop()
            case .failure(let error):
                Spinner.stop()
                log("Failed to reopen issue \(error.localizedDescription)")
            }
        }
    }
}
