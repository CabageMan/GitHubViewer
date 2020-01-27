import Foundation

final class RepositoriesVM {
    
    //MARK: - API
    private var paginator = PaginationManager()
    
    var ownerHasBeenFetched: () -> Void = { }
    var repositoriesHaveBeenFetched: ([Repository]) -> Void = { _ in }
    
    func resetPaginationOptions() {
        paginator = PaginationManager()
    }
    
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
    
    func getOwnRepositories() {
        guard let owner = Global.apiClient.ownUser else { return }
        let order = RepositoryOrder(field: .createdAt, direction: .desc)
        GitHubViewerApollo.shared.client.fetch(query: UserRepositoriesQuery(userLogin: owner.login, numberOfRepositories: paginator.itemsNumber, cursor: paginator.cursor, order: order), cachePolicy: .fetchIgnoringCacheCompletely) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                guard
                    let data = result.data?.user?.repositories,
                    let repositories = data.edges?
                        .compactMap({ $0?.node?.fragments.repositoriesListFragment })
                        .map({ Repository(repo: $0) })
                else {
                    log("Failed to load repositories info")
                    return
                }
                let pageInfo = data.pageInfo
                
                if self.paginator.hasNextPage == nil {
                    self.paginator.hasNextPage = pageInfo.hasNextPage
                }

                if self.paginator.hasNextPage! || !repositories.isEmpty {
                    Global.apiClient.ownUser?.setRepositories(repositories)
                    self.repositoriesHaveBeenFetched(repositories)
                    self.paginator.cursor = pageInfo.endCursor
                } else {
                    self.repositoriesHaveBeenFetched([])
                }
                
                self.paginator.hasNextPage = pageInfo.hasNextPage
            case .failure(let error):
                log("Error fetching own repositories: \(error.localizedDescription)")
            }
            
        }
    }
    
    func findRepository(ownerLogin: String, repositoryName: String, completion: @escaping (Repository) -> Void) {
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
