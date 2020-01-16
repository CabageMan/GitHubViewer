import Foundation

struct IssueComment {
    let id: String
    let bodyText: String
    let authorLogin: String
    let authorAvatarURL: String
    let createdAt: Date
    
    init(comment: IssueCommentFragment) {
        self.id = comment.id
        self.bodyText = comment.bodyText
        self.authorLogin = comment.author?.login ?? ""
        self.authorAvatarURL = comment.author?.avatarUrl ?? ""
        self.createdAt = ISO8601DateFormatter().date(from: comment.createdAt) ?? Date()
    }
}
