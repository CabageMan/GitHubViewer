import Foundation

final class RepositoryDetailsVM {
    
    var repositoryOwnerLogin: String?
    var repository: Repository?
    
    var repositoryHasBeenFetched: (RepositoryDetails) -> Void = { _ in }
    
    func getRepositoryInfo() {
        guard let owner = repositoryOwnerLogin, let repo = repository else { return }
        GitHubViewerApollo.shared.client.fetch(query: RepositoryDetailsQuery(ownerLogin: owner, repositoryName: repo.name)) { [weak self] response in
            switch response {
            case .success(let result):
                guard let details = result.data?.repository?.fragments.repositoryDetailsFragment else { return }
                let repositoryDetails = RepositoryDetails(repo: repo, details: details)
                self?.repositoryHasBeenFetched(repositoryDetails)
            case .failure(let error):
                log("Error fetching repository info:\n\(error.localizedDescription)")
            }
        }
    }
    
}
