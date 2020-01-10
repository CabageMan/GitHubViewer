import Foundation

final class IssuesVM {
    
    //MARK: - API
    typealias SelectorState = CollectionSelectorHeader.SelectorState
    
    private let issuesNumber = 23
    
    private var allIssues: [Issue] = []
    var issuesHaveBeenFetched: () -> Void = { }
    
    func getOwnIssues() {
        guard let owner = Global.apiClient.ownUser else { return }
        let order = IssueOrder(field: .createdAt, direction: .desc)
        GitHubViewerApollo.shared.client.fetch(query: UserIssuesQuery(userLogin: owner.login, numberOfIssues: issuesNumber, order: order)) { [weak self] response in
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
                #warning("Rework pagination!")
                log("Issues has next page: \(data.pageInfo.hasNextPage)")
                self.allIssues = issues
                self.issuesHaveBeenFetched()
                
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
