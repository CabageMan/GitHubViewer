import Foundation

enum ProfileItem {
        
    struct PinnedItems {
        let repositories: [Repository]
        let gists: [Gist]
    }
    
    case user(User)
    case pinned(PinnedItems)
    case contributions([ContributionsCollection.ContributionDay], (ContributionsCollection.ContributionDay) -> Void)
    case empty
    
}
