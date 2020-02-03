import Foundation

final class IssuesVM {
    
    //MARK: - API
    typealias SelectorState = CollectionSelectorHeader.SelectorState
    
    private var paginator = PaginationManager()
    
    private var allIssues: [Issue] = []
    var issuesHaveBeenFetched: () -> Void = { }
    
    func resetDataSource() {
        allIssues = []
        paginator = PaginationManager()
    }
    
    func getOwnIssues() {
        guard let owner = Global.apiClient.ownUser else { return }
        let order = IssueOrder(field: .createdAt, direction: .desc)
        GitHubViewerApollo.shared.client.fetch(query: UserIssuesQuery(userLogin: owner.login, numberOfIssues: paginator.itemsNumber, cursor: paginator.cursor, order: order), cachePolicy: .fetchIgnoringCacheCompletely) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                guard
                    let data = result.data?.user?.issues,
                    let issues = data.edges?
                        .compactMap({ $0?.node?.fragments.issuesListFragment })
                        .map({ Issue(issue: $0) })
                else {
                    log("Failed to load pull requests info ")
                    return
                }
                let pageInfo = data.pageInfo
                
                if self.paginator.hasNextPage == nil {
                    self.paginator.hasNextPage = pageInfo.hasNextPage
                }
                
                if self.paginator.hasNextPage! || !issues.isEmpty {
                    self.allIssues += issues
                    self.issuesHaveBeenFetched()
                    self.paginator.cursor = pageInfo.endCursor
                } else {
                    self.allIssues += []
                    self.issuesHaveBeenFetched()
                }
                
                self.paginator.hasNextPage = pageInfo.hasNextPage
            case .failure(let error):
                log("Error fetching own issues \(error.localizedDescription)")
            }
        }
    }
    
    func getIssues(for page: PageMode, selector: SelectorState) -> [Issue] {
        switch page {
        case .created:
            guard let owner = Global.apiClient.ownUser?.login else { return [] }
            return allIssues.filter { $0.author == owner && stateMatch(selectorState: selector, issueState: $0.state) }
        case .assigned:
            return allIssues.filter { $0.assignees.contains(Global.apiClient.ownUser?.login) && stateMatch(selectorState: selector, issueState: $0.state) }
        case .mentioned:
            Global.showComingSoon()
            return []
        default: return[]
        }
    }
    
    private func stateMatch(selectorState: SelectorState, issueState: IssueState ) -> Bool {
        switch selectorState {
        case .open:
            return issueState == .open
        case .closed:
            return issueState == .closed
        }
    }
}
