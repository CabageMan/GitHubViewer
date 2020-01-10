import Foundation

enum PagesMode: Int {
    case created = 0
    case assigned
    case mentioned
    case reviewRequests
    
    static var all: [PagesMode] {
        return [.created, .assigned, .mentioned, .reviewRequests]
    }
    
    static var issueMode: [PagesMode] {
        return [.created, .assigned, .mentioned]
    }
    
    var title: String {
        switch self {
        case .created: return String.PagesMode.created
        case .assigned: return String.PagesMode.assigned
        case .mentioned: return String.PagesMode.mentioned
        case .reviewRequests: return String.PagesMode.reviewRequests
        }
    }
}
