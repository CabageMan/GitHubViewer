import Foundation

final class PullRequestsVM {
    
    //MARK: - API
    private let prCount = 10
    private var lastPRCursor: String?
    private var hasNextPage: Bool?
    
    private var allPullRequests: [PullRequest] = []
    var pullRequestsHaveBeenFetched: () -> Void = { }
    
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
                    self.allPullRequests = pullRequests
                    self.pullRequestsHaveBeenFetched()
                    self.lastPRCursor = pageInfo.endCursor
                } else {
                    self.allPullRequests = []
                    self.pullRequestsHaveBeenFetched()
                }
                
                self.hasNextPage = pageInfo.hasNextPage
            case .failure(let error):
                log("Error fetching own pull requests \(error.localizedDescription)")
            }
        }
    }
    
    func getPullRequests(for page: PullRequestsVC.Page) -> [PullRequest] {
        switch page {
        case .created:
            guard let owner = Global.apiClient.ownUser?.login else { return [] }
            return allPullRequests.filter { $0.author == owner }
        case .assigned:
            return allPullRequests.filter { $0.assignees.contains(Global.apiClient.ownUser?.login) }
        case .mentioned:
            Global.showComingSoon()
            return []
        case .reviewRequests:
            Global.showComingSoon()
            return []
        }
    }
}
