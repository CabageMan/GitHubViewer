import Foundation

final class RepositoriesVM {
    
    //MARK: - API
//    private let repositoriesPaginator = PaginationManager(count: 5)
    
    var ownerHasBeenFetched: () -> Void = { }
    var repositoriesHaveBeenFetched: ([Repository]) -> Void = { _ in }
    
    func getOwnUser() {
        GitHubViewerApollo.shared.client.fetch(query: OwnUserQuery()) { [weak self] response in
            switch response {
            case .success(let result):
                guard let viewer = result.data?.viewer.fragments.userFragment else {
                    log("Failed to load owner info")
                    return
                }
                Global.apiClient.ownUser = User(user: viewer)
                self?.ownerHasBeenFetched()
            case .failure(let error):
                log("Error fetching own user: \(error.localizedDescription)")
            }
        }
    }
    
    var cursor: String? = nil
    var hasNextPage: Bool? = nil
    
    func getOwnRepositories() {
        guard let owner = Global.apiClient.ownUser else { return }
        let order = RepositoryOrder(field: .createdAt, direction: .desc)
//        let paginatorOptions = repositoriesPaginator.options
        GitHubViewerApollo.shared.client.fetch(query: UserRepositoriesQuery(userLogin: owner.login, numberOfRepositories: 5, cursor: cursor, order: order)) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                #warning("Think how to rework get repositories logic")
                //#################################
                guard
                    let repositories = result.data?.user?.repositories.edges?.compactMap({ $0?.node?.fragments.repositoriesListFragment }).map({ Repository(repo: $0) }),
                    let totalCount = result.data?.user?.repositories.totalCount,
                    let pageInfo = result.data?.user?.repositories.pageInfo
                else {
                    log("Failed to load owner info")
                    return
                }
                
                if self.hasNextPage == nil {
                    self.hasNextPage = pageInfo.hasNextPage
                }

                if self.hasNextPage! {
                    Global.apiClient.ownUser?.setRepositories(repositories)
                    self.repositoriesHaveBeenFetched(repositories)
                    self.cursor = pageInfo.endCursor
                } else {
                    self.repositoriesHaveBeenFetched([])
                }
                
                self.hasNextPage = pageInfo.hasNextPage
                log("\nLast cursor: \(self.cursor)\nEnd Cursor: \(pageInfo.endCursor)\nHasNextPage: \(pageInfo.hasNextPage)")
                log("Repositories: \(repositories)")
                //#################################
            case .failure(let error):
                log("Error fetching own user: \(error.localizedDescription)")
            }
            
        }
    }
    
    func findRepository(ownerLogin: String, repositoryName: String, completion: @escaping (Repository) -> Void) {
        log("")
        GitHubViewerApollo.shared.client.fetch(query: FindRepositoryQuery(ownerLogin: ownerLogin, repositoryName: repositoryName)) { response in
            switch response {
            case .success(let result):
                guard let repository = result.data?.repository?.fragments.repositoriesListFragment else {
                    log("Failed to load repository")
                    return
                }
                completion(Repository(repo: repository))
            case .failure(let error):
                log("Error fetching repository:\n\(error.localizedDescription)")
            }
        }
    }
}
