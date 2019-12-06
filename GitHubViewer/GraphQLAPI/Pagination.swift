import Foundation
#warning("Think how to rework paginator logic")
public struct PaginationOptions {
    public let count: Int
    public let lastCursor: String?
}

final class PaginationManager {
    var defaultCount: Int = 10
    var totalItemCount: Int? = 0
    lazy var options = PaginationOptions(count: defaultCount, lastCursor: nil)
    
    init(count: Int? = nil) {
        if let newCount = count {
            self.defaultCount = newCount
        }
    }
    
    func next(endCursor: String?, hasNextPage: Bool?, total: Int?, count: Int? = nil) {
        guard endCursor != nil, hasNextPage != nil else { return }
        if hasNextPage! {
            self.totalItemCount = total
            self.options = PaginationOptions(count: count ?? defaultCount, lastCursor: endCursor!)
        }
    }
}
