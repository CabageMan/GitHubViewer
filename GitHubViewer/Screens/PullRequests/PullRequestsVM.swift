import Foundation

final class PullRequestsVM {
    
    //MARK: - API
    typealias SelectorState = CollectionSelectorHeader.SelectorState
    
    private var paginator = PaginationManager()
    
    private var allPullRequests: [PullRequest] = []
    var pullRequestsHaveBeenFetched: () -> Void = { }
    
    func resetDataSource() {
        allPullRequests = []
        paginator = PaginationManager()
    }
    
    func getOwnPullRequests() {
        guard let owner = Global.apiClient.ownUser else { return }
        let order = IssueOrder(field: .createdAt, direction: .desc)
        GitHubViewerApollo.shared.client.fetch(query: UserPullRequestsQuery(userLogin: owner.login, numberOfRequests: paginator.itemsNumber, cursor: paginator.cursor, order: order), cachePolicy: .fetchIgnoringCacheCompletely) { [weak self] response in
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
                
                if self.paginator.hasNextPage == nil {
                    self.paginator.hasNextPage = pageInfo.hasNextPage
                }
                
                if self.paginator.hasNextPage! || !pullRequests.isEmpty {
                    self.allPullRequests += pullRequests
                    self.pullRequestsHaveBeenFetched()
                    self.paginator.cursor = pageInfo.endCursor
                } else {
                    self.allPullRequests += []
                    self.pullRequestsHaveBeenFetched()
                }
                
                self.paginator.hasNextPage = pageInfo.hasNextPage
            case .failure(let error):
                log("Error fetching own pull requests \(error.localizedDescription)")
            }
        }
    }
    
    func getPullRequests(for page: PageMode, selector: SelectorState) -> [PullRequest] {
        switch page {
        case .created:
            guard let owner = Global.apiClient.ownUser?.login else { return [] }
            return allPullRequests.filter { $0.author == owner && stateMatch(selectorState: selector, prState: $0.state) }
        case .assigned:
            return allPullRequests.filter { $0.assignees.contains(Global.apiClient.ownUser?.login) && stateMatch(selectorState: selector, prState: $0.state) }
        case .mentioned:
            Global.showComingSoon()
            return []
        case .reviewRequests:
            Global.showComingSoon()
            return []
        }
    }
    
    private func stateMatch(selectorState: SelectorState, prState: PullRequestState) -> Bool {
        switch selectorState {
        case .open:
            return prState == .open
        case .closed:
            return prState == .closed || prState == .merged
        }
    }
}
