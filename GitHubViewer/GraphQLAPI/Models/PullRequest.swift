import Foundation

struct PullRequest {
    let id: String
    let state: PullRequestState
    let author: String?
    let headRefName: String
    let baseRefName: String
    var baseRepository: Repository?
    var assignees: [String?]
    
    init(request: PullRequestsListFragment) {
        self.id = request.id
        self.state = request.state
        self.author = request.author?.login
        self.headRefName = request.headRefName
        self.baseRefName = request.baseRefName
        self.assignees = (request.assignees.edges?.compactMap({ $0?.node }).map({ $0.login })) ?? []
        if let repository = request.baseRepository?.fragments.repositoriesListFragment {
            self.baseRepository = Repository(repo: repository)
        }
    }
}
