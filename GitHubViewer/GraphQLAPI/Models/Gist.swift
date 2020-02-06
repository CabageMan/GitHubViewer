import Foundation

struct Gist {
    let id: String
    let name: String
    let createdAt: Date
    let resourcePath: String
    var isPublic: Bool
    let isFork: Bool
    var description: String?
    
    init(gist: GistsListFragment) {
        self.id = gist.id
        self.name = gist.name
        self.createdAt = ISO8601DateFormatter().date(from: gist.createdAt) ?? Date()
        self.resourcePath = String(gist.resourcePath.dropFirst())
        self.isPublic = gist.isPublic
        self.isFork = gist.isFork
        self.description = gist.description
    }
}
