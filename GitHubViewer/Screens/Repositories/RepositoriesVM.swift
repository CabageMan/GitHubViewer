import Foundation

final class RepositoriesVM {
    
    //MARK: - API
    var ownerHasBeenFetched: ([Repository]) -> Void = { _ in }
    
    func getOwnUser() {
        let order = RepositoryOrder(field: .createdAt, direction: .desc)
        GitHubViewerApollo.shared.client.fetch(query: OwnUserQuery(order: order, numberOfRepositories: 30)) { [weak self] response in
            switch response {
            case .success(let result):
                guard let viewer = result.data?.viewer.fragments.userFragment else {
                    log("Failed to load owner info")
                    return
                }
                Global.apiClient.ownUser = User(user: viewer)
                if let repositories = Global.apiClient.ownUser?.repositories {
                    self?.ownerHasBeenFetched(repositories)
                }
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
