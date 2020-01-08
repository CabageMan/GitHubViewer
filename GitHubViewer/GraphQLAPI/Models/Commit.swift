import Foundation

struct Commit {
    let id: String
    let message: String
    
    init(commit: CommitListFragment) {
        self.id = commit.id
        self.message = commit.message
    }
}
