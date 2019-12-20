import Foundation

final class RepositoriesVM {
    
    //MARK: - API
    private let repositoriesCount = 10
    private var lastRepositoryCursor: String?
    private var hasNextPage: Bool?
    
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
    
    func getOwnRepositories() {
        guard let owner = Global.apiClient.ownUser else { return }
        let order = RepositoryOrder(field: .createdAt, direction: .desc)
        GitHubViewerApollo.shared.client.fetch(query: UserRepositoriesQuery(userLogin: owner.login, numberOfRepositories: repositoriesCount, cursor: lastRepositoryCursor, order: order)) { [weak self] response in
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
                #warning("Need improove pagination!")
                if self.hasNextPage == nil {
                    self.hasNextPage = pageInfo.hasNextPage
                }

                if self.hasNextPage! {
                    Global.apiClient.ownUser?.setRepositories(repositories)
                    self.repositoriesHaveBeenFetched(repositories)
                    self.lastRepositoryCursor = pageInfo.endCursor
                } else {
                    self.repositoriesHaveBeenFetched([])
                }
                
                self.hasNextPage = pageInfo.hasNextPage
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
    
    //MARK: - Actions
    func resetPaginationOptions() {
        lastRepositoryCursor = nil
        hasNextPage = nil
    }
}
