import Foundation

struct PullRequest {
    let id: String
    let headRefName: String
    let baseRefName: String
    var baseRepository: Repository?
    
    init(request: PullRequestsListFragment) {
        self.id = request.id
        self.headRefName = request.headRefName
        self.baseRefName = request.baseRefName
        if let repository = request.baseRepository?.fragments.repositoriesListFragment {
            self.baseRepository = Repository(repo: repository)
        }
    }
}
