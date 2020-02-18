import Foundation

final class ProfileVM {
    
    private(set) var pinnedRepositories: [Repository] = []
    private(set) var pinnedGists: [Gist] = []
    private(set) var contributionsCollection: ContributionsCollection?
    
    var pinnedItemsHaveBeenFetched: () -> Void = { }
    var contributionsHaveBeenFetched: () -> Void = { }
    
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
                self.pinnedItemsHaveBeenFetched()
            case .failure(let error):
                log("Error fetching pinned items: \(error.localizedDescription)")
            }
        }
    }
    
    func getContributionsHistory() {
        guard let owner = Global.apiClient.ownUser else { return }
        let fromDate = getStartDate()
        let toDate = getEndDate()
        
        GitHubViewerApollo.shared.client.fetch(query: ContributionsQuery(userLogin: owner.login, from: fromDate, to: toDate), cachePolicy: .fetchIgnoringCacheCompletely) { [weak self] response in
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
    
    //MARK: - Temporary
    private func getStartDate() -> String {
        var dateComponents = DateComponents()
        dateComponents.day = 1
        dateComponents.month = 1
        dateComponents.year = 2019
        guard let date = Calendar.current.date(from: dateComponents) else { return Date().iso8601 }
        return Calendar.current.startOfDay(for: date).iso8601
    }
    
    private func getEndDate() -> String {
        var dateComponents = DateComponents()
        dateComponents.day = 31
        dateComponents.month = 12
        dateComponents.year = 2019
        guard let date = Calendar.current.date(from: dateComponents), let endDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: date) else { return Date().iso8601 }
        return endDate.iso8601
    }
}

//MARK: - ISO8601 converting
extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options, timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) {
        self.init()
        self.formatOptions = formatOptions
        self.timeZone = timeZone
    }
}

extension Formatter {
    static let iso8601 = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}

extension Date {
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}

extension String {
    var iso8601: Date? {
        return Formatter.iso8601.date(from: self)
    }
}
