import Foundation

final class IssuesVM {
    
    //MARK: - API
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
                log("Issues: \(issues)")
                
            case .failure(let error):
                log("Error fetching own issues \(error.localizedDescription)")
            }
        }
    }
    
    #warning("Need make methods of state match and getSeparated date generic")
}
