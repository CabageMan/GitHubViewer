import Foundation

struct User {
    let name: String
    let login: String
    let avatarURL: String
    let email: String
    private(set) var repositories: [Repository]?
    
    init(user: UserFragment) {
        self.name = user.name ?? ""
        self.login = user.login
        self.avatarURL = user.avatarUrl
        self.email = user.email
    }
    
    mutating func setRepositories(_ repositories: [Repository]) {
        self.repositories = repositories
    }
}
