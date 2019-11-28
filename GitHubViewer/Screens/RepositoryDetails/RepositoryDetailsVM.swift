import Foundation

final class RepositoryDetailsVM {
    
    typealias InfoItem = DetailsCardsView.InfoItem
    typealias LinkItem = DetailsCardsView.LinkItem
    
    var repositoryOwnerLogin: String?
    var repository: Repository?
    
    private var repositoryDetails: RepositoryDetails?
    
    var repositoryHasBeenFetched: () -> Void = { }
    
    func getRepositoryInfo() {
        guard let owner = repositoryOwnerLogin, let repo = repository else { return }
        GitHubViewerApollo.shared.client.fetch(query: RepositoryDetailsQuery(ownerLogin: owner, repositoryName: repo.name)) { [weak self] response in
            switch response {
            case .success(let result):
                guard let details = result.data?.repository?.fragments.repositoryDetailsFragment else { return }
                self?.repositoryDetails = RepositoryDetails(repo: repo, details: details)
                self?.repositoryHasBeenFetched()
            case .failure(let error):
                log("Error fetching repository info:\n\(error.localizedDescription)")
            }
        }
    }
    
    func createInfoContent() -> [InfoItem] {
        guard let details = repositoryDetails else { return [] }
        #warning("Need to localize dates")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm"
        var infoItems: [InfoItem] = []
        
        if let createdAt = details.repository.createdAt {
            infoItems.append(InfoItem(title: String.Repos.createdAt, details: formatter.string(from: createdAt)))
        }
        if let updatedAt = details.updatedAt {
            infoItems.append(InfoItem(title: String.Repos.updatedAt, details: formatter.string(from: updatedAt)))
        }
        if let pushedAt = details.pushedAt {
            infoItems.append(InfoItem(title: String.Repos.pushedAt, details: formatter.string(from: pushedAt)))
        }
        if let repoDescription = details.repository.description {
            infoItems.append(InfoItem(title: String.Repos.descriprion, details: repoDescription))
        }
        if let repoParent = details.parent {
            infoItems.append(InfoItem(title: String.Repos.parent, details: repoParent.name))
        }
        
        return infoItems
    }
    
    func createLinksContent(with action: @escaping (String) -> Void) -> [LinkItem] {
        guard let details = repositoryDetails else { return [] }
        return [LinkItem(title: String.Repos.url, url: details.url, action: action)]
    }
}
