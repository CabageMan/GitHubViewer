import Foundation

struct ContributionsCollection {
    let hasAnyContributions: Bool
    let contributionsYears: [Int]
    let startedAt: Date
    let endedAt: Date
    let calendar: ContributionCalendar
    
    init(collection: ContributionsCollectionFragment) {
        self.hasAnyContributions = collection.hasAnyContributions
        self.contributionsYears = collection.contributionYears
        self.calendar = ContributionCalendar(calendar: collection.contributionCalendar.fragments.contributionCalendarFragment)
        self.startedAt = ISO8601DateFormatter().date(from: collection.startedAt) ?? Date()
        self.endedAt = ISO8601DateFormatter().date(from: collection.endedAt) ?? Date()
    }
}

//MARK: - Contribution Calendar Elements

extension ContributionsCollection {
    
    struct ContributionCalendar {
        let totalContributions: Int
        let colors: [String]
        let months: [ContributionMonth]
        let weeks: [ContributionWeek]
        
        init(calendar: ContributionCalendarFragment) {
            self.totalContributions = calendar.totalContributions
            self.colors = calendar.colors
            self.months = calendar.months.map { ContributionMonth(month: $0.fragments.contributionMonthFragment) }
            self.weeks = calendar.weeks.map { ContributionWeek(week: $0.fragments.contributionWeekFragment) }
        }
    }
    
    struct ContributionMonth {
        let name: String
        let year: Int
        let totalWeeks: Int
        
        init(month: ContributionMonthFragment) {
            self.name = month.name
            self.year = month.year
            self.totalWeeks = month.totalWeeks
        }
    }
    
    struct ContributionWeek {
        let firstDay: Date
        let days: [ContributionDay]
        
        init(week: ContributionWeekFragment) {
            self.firstDay = ISO8601DateFormatter().date(from: week.firstDay) ?? Date()
            self.days = week.contributionDays.map { ContributionDay(day: $0.fragments.contributionDayFragment) }
        }
    }
    
    struct ContributionDay {
        let contributionCount: Int
        let color: String
        let weekday: WeekDay
        let date: Date
        
        init(day: ContributionDayFragment) {
            self.contributionCount = day.contributionCount
            self.color = day.color
            self.weekday = WeekDay(rawValue: day.weekday) ?? .undefined
            log("Date: \(day.date)")
            self.date = ISO8601DateFormatter().date(from: day.date) ?? Date()
        }
    }
    
    enum WeekDay: Int {
        case sun = 0
        case mon
        case tue
        case wed
        case thu
        case fri
        case sat
        case undefined
        
        var fullName: String {
            switch self {
            case .sun: return String.Calendar.sunday
            case .mon: return String.Calendar.monday
            case .tue: return String.Calendar.tuesday
            case .wed: return String.Calendar.wednesday
            case .thu: return String.Calendar.thursday
            case .fri: return String.Calendar.friday
            case .sat: return String.Calendar.saturday
            default: return ""
            }
        }
        
        var shortName: String {
            switch self {
            case .sun: return String.Calendar.sun
            case .mon: return String.Calendar.mon
            case .tue: return String.Calendar.tue
            case .wed: return String.Calendar.wed
            case .thu: return String.Calendar.thu
            case .fri: return String.Calendar.fri
            case .sat: return String.Calendar.sat
            default: return ""
            }
        }
    }
}
