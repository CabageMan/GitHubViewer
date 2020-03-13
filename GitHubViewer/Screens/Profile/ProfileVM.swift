import Foundation

final class ProfileVM {
    
    private(set) var pinnedItems: [ProfilePinnedItem] = []
    private(set) var contributionsCollection: ContributionsCollection?
    
    var pinnedItemsHaveBeenFetched: () -> Void = { }
    var contributionsHaveBeenFetched: () -> Void = { }
    
    //MARK: - Actions
    func getPinnedItems() {
        pinnedItems = []
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
                        self.pinnedItems.append(.repository(Repository(repo: repo)))
                    case .gist:
                        guard let gist = $0.asGist?.fragments.gistsListFragment else { return }
                        self.pinnedItems.append(.gist(Gist(gist: gist)))
                    default: return
                    }
                }
                self.pinnedItemsHaveBeenFetched()
            case .failure(let error):
                log("Error fetching pinned items: \(error.localizedDescription)")
            }
        }
    }
    
    func getContributionsHistory(fromDate: Date, toDate: Date) {
        contributionsCollection = nil
        guard let owner = Global.apiClient.ownUser else { return }
        GitHubViewerApollo.shared.client.fetch(query: ContributionsQuery(userLogin: owner.login, from: fromDate.startOfDay.iso8601, to: toDate.endOfDay.iso8601), cachePolicy: .fetchIgnoringCacheCompletely) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                guard let data = result.data?.user?.contributionsCollection.fragments.contributionsCollectionFragment else {
                    log("Failed to load contributions history")
                    return
                }
                self.contributionsCollection = ContributionsCollection(collection: data)
                self.contributionsHaveBeenFetched()
            case .failure(let error):
                log("Error fetching contributions: \(error.localizedDescription)")
            }
        }
    }
    
    typealias ContributionsDay = ContributionsCollection.ContributionDay
    
    func getContributionsDays() -> [ContributionsDay] {
        var contributionsDays: [ContributionsDay] = []
        contributionsCollection?.calendar.weeks.forEach { week in
            week.days.forEach { day in
                if day.contributionCount > 0 {
                    contributionsDays.append(day)
                }
            }
        }
        return contributionsDays
    }
}
