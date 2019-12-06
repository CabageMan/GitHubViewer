import Foundation
#warning("Need to think about user model.")
// Set repositories and other properties by functions or directly. By functions we can control what we set.
struct User {
    let name: String
    let login: String
    let avatarURL: String
    private(set) var repositories: [Repository]?
    
    init(user: UserFragment) {
        self.name = user.name ?? ""
        self.login = user.login
        self.avatarURL = user.avatarUrl
    }
    
    mutating func setRepositories(_ repositories: [Repository]) {
        self.repositories = repositories
    }
}
