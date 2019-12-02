import Foundation

final class RepositoryDetailsVM {
    
    //MARK: - API
    var repositoryOwnerLogin: String?
    var repository: Repository?
    
    private var repositoryDetails: RepositoryDetails?
    
    var repositoryHasBeenFetched: () -> Void = { }
    
    func getRepositoryInfo() {
        guard let owner = repositoryOwnerLogin, let repo = repository else { return }
        let order = RepositoryOrder(field: .createdAt, direction: .desc)
        GitHubViewerApollo.shared.client.fetch(query: RepositoryDetailsQuery(ownerLogin: owner, repositoryName: repo.name, order: order, numberOfRepositories: 30)) { [weak self] response in
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
}

//MARK: - Creating Content
extension RepositoryDetailsVM {
    typealias Section = RepositoryDetailsTableView.Section
    typealias InfoItem = RepositoryDetailsTableView.InfoItem
    typealias LinkItem = RepositoryDetailsTableView.LinkItem
    
    func createSections() -> [Section] {
        guard let details = repositoryDetails else { return [] }
        var sections: [Section] = []
        
        sections.append(.info(createInfoItems(from: details)))
        sections.append(.links(LinkItem(title: String.Repos.url, url: details.url)))
        sections.append(.assignableUsers(details.assignableUsers))
        
        return sections
    }
    
    private func createInfoItems(from details: RepositoryDetails) -> [InfoItem] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm"
        var infoItems: [InfoItem] = []
        
        if let description = details.repository.description {
            infoItems.append(InfoItem(title: String.Repos.descriprion, details: description))
        }
        if let createdAt = details.repository.createdAt {
            infoItems.append(InfoItem(title: String.Repos.createdAt, details: formatter.string(from: createdAt)))
        }
        if let updatedAt = details.updatedAt {
            infoItems.append(InfoItem(title: String.Repos.updatedAt, details: formatter.string(from: updatedAt)))
        }
        if let pushedAt = details.pushedAt {
            infoItems.append(InfoItem(title: String.Repos.pushedAt, details: formatter.string(from: pushedAt)))
        }
        if let parent = details.parent {
            infoItems.append(InfoItem(title: String.Repos.parent, details: parent.name))
        }
        return infoItems
    }
}
