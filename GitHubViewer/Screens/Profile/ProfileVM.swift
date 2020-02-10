import Foundation

final class ProfileVM {
    
    private(set) var pinnedRepositories: [Repository] = []
    private(set) var pinnedGists: [Gist] = []
    
    var pinnedItemsHaveBeenFetched: () -> Void = { }
    
    //MARK: - Actions
    func getPinnedItems() {
        guard let owner = Global.apiClient.ownUser else { return }
        let pinnedTypes: [PinnableItemType] = [.repository, .gist]
        GitHubViewerApollo.shared.client.fetch(query: ProfilePinnedItemsQuery(userLogin: owner.login, numberOfItems: 6, pinnedTypes: pinnedTypes), cachePolicy: .fetchIgnoringCacheCompletely) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                guard let data = result.data?.user?.pinnedItems.edges else {
                    log("Failed to load pinned items")
                    return
                }
                data.compactMap({$0?.node}).forEach {
                    let typeName = PinnableItemType(rawValue: $0.__typename.uppercased())
                    switch typeName {
                    case .repository:
                        guard let repo = $0.asRepository?.fragments.repositoriesListFragment else { return }
                        self.pinnedRepositories.append(Repository(repo: repo))
                    case .gist:
                        guard let gist = $0.asGist?.fragments.gistsListFragment else { return }
                        self.pinnedGists.append(Gist(gist: gist))
                    default: return
                    }
                }
                log("Result:\nRepositories: \(self.pinnedRepositories)\nGists: \(self.pinnedGists)")
            case .failure(let error):
                log("Error fetching pinned items: \(error.localizedDescription)")
            }
        }
    }
    
    
    //TODO: - Need to create query "contributionsCollection"
}
