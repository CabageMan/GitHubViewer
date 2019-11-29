import Foundation

final class RepositoriesVM {
    
    //MARK: - API
    var ownerHasBeenFetched: ([Repository]) -> Void = { _ in }
    
    func getOwnUser() {
        let order = RepositoryOrder(field: .createdAt, direction: .desc)
        GitHubViewerApollo.shared.client.fetch(query: OwnUserQuery(order: order, numberOfRepositories: 30)) { [weak self] response in
            switch response {
            case .success(let result):
                guard let viewer = result.data?.viewer.fragments.userFragment else { return }
                Global.apiClient.ownUser = User(user: viewer)
                if let repositories = Global.apiClient.ownUser?.repositories {
                    self?.ownerHasBeenFetched(repositories)
                }
            case .failure(let error):
                log("Error fetching own user: \(error.localizedDescription)")
            }
        }
    }
    
}
