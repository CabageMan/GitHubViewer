import Foundation

final class PullRequestsVM {
    
    //MARK: - API
    private let prCount = 5
    private var lastPRCursor: String?
    private var hasNextPage: Bool?
    
    var pullRequestsHaveBeenFetched: ([PullRequest]) -> Void = { _ in }
    
    func getOwnPullRequests() {
        guard let owner = Global.apiClient.ownUser else { return }
        let order = IssueOrder(field: .createdAt, direction: .desc)
        GitHubViewerApollo.shared.client.fetch(query: UserPullRequestsQuery(userLogin: owner.login, numberOfRequests: prCount, cursor: lastPRCursor, order: order)) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                guard
                    let data = result.data?.user?.pullRequests,
                    let pullRequests = data.edges?
                        .compactMap({ $0?.node?.fragments.pullRequestsListFragment })
                        .map({ PullRequest(request: $0) })
                else {
                    log("Failed to load pull requests info ")
                    return
                }
                let pageInfo = data.pageInfo
                #warning("Need improove pagination!")
                if self.hasNextPage == nil {
                    self.hasNextPage = pageInfo.hasNextPage
                }
                
                if self.hasNextPage! {
                    // May be save owner pull requests
                    self.pullRequestsHaveBeenFetched(pullRequests)
                    self.lastPRCursor = pageInfo.endCursor
                } else {
                    self.pullRequestsHaveBeenFetched([])
                }
                
                self.hasNextPage = pageInfo.hasNextPage
            case .failure(let error):
                log("Error fetching own pull requests \(error.localizedDescription)")
            }
        }
    }
}
