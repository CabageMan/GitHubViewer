import Foundation

struct ContributionsCollection {
    struct ContributionCalendar {
        let totalContributions: Int
        let months: [String]
        
        init(calendar: ContributionCalendarFragment) {
            self.totalContributions = calendar.totalContributions
            self.months = calendar.months.map { $0.name }
        }
    }
    
    let hasAnyContributions: Bool
    let contributionsYears: [Int]
    let calendar: ContributionCalendar
    let startedAt: Date
    let endedAt: Date
    
    init(collection: ContributionsCollectionFragment) {
        self.hasAnyContributions = collection.hasAnyContributions
        self.contributionsYears = collection.contributionYears
        self.calendar = ContributionCalendar(calendar: collection.contributionCalendar.fragments.contributionCalendarFragment)
        self.startedAt = ISO8601DateFormatter().date(from: collection.startedAt) ?? Date()
        self.endedAt = ISO8601DateFormatter().date(from: collection.endedAt) ?? Date()
    }
}
