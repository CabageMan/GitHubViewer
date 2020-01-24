import Foundation

final class IssueDetailsVM {
    
    let router: GithubViewerRouter
    
    var issue: Issue
    
    var commentSended: () -> Void = { }
    var issueClosed: () -> Void = { }
    
    //MARK: -Initializers
    init(router: GithubViewerRouter, issue: Issue) {
        self.router = router
        self.issue = issue
    }
    
    //MARK: -Actions
    func closeIssue() {
        Spinner.start()
        issueClosed()
        Spinner.stop()
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
                self.commentSended()
                Spinner.stop()
            case .failure(let error):
                Spinner.stop()
                log("Failure to send comment \(error.localizedDescription)")
            }
        }
    }
}
