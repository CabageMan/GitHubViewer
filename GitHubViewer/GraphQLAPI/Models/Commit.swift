import Foundation

struct Commit {
    let id: String
    
    init(commit: CommitListFragment) {
        self.id = commit.id
    }
}
