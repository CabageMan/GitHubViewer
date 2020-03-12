import Foundation

enum ProfileItem {
        
    struct PinnedItems {
        let repositories: [Repository]
        let gists: [Gist]
    }
    
    struct Contributions {
        let contributionsStartedAt: Int?
        let contributionsYears: [Int]
        let contributionsDays: [ContributionsCollection.ContributionDay]
        let onBarSelect: (ContributionsCollection.ContributionDay) -> Void
        let onYearSelect: (Int) -> Void
    }
    
    case user(User)
    case pinned(PinnedItems)
    case contributions(Contributions)
    case empty
    
}
