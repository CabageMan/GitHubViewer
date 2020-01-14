import Foundation

struct IssueComment {
    let id: String
    let bodyText: String
    let author: String
    let createdAt: Date
    
    init(comment: IssueCommentFragment) {
        self.id = comment.id
        self.bodyText = comment.bodyText
        self.author = comment.author?.login ?? ""
        self.createdAt = ISO8601DateFormatter().date(from: comment.createdAt) ?? Date()
    }
}
