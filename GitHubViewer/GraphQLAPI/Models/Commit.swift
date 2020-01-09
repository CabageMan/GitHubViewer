import Foundation

struct Commit {
    let id: String
    let abbreviatedOid: String
    let message: String
    
    init(commit: CommitListFragment) {
        self.id = commit.id
        self.abbreviatedOid = commit.abbreviatedOid
        self.message = commit.message
    }
}
