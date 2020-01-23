import Foundation

final class IssueDetailsVM {
    
    let router: GithubViewerRouter
    
    var issue: Issue
    
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
        let commentInput = AddCommentInput(subjectId: issue.id, body: comment)
        GitHubViewerApollo.shared.client.perform(mutation: AddCommentToIssueMutation(issueComment: commentInput)) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                log("Issue: \(result)")
            case .failure(let error):
                log("Failure to send comment \(error.localizedDescription)")
            }
        }
        commentSended(true)
    }
}
