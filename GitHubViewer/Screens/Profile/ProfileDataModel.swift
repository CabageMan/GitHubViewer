import Foundation

enum ProfileItem {
    typealias ContributionDay = ContributionsCollection.ContributionDay
        
    struct PinnedItems {
        let repositories: [Repository]
        let gists: [Gist]
    }
    
    case user(User)
    case pinned(PinnedItems)
    case contributions([ContributionDay])
    case empty
}
