import Foundation

final class PaginationManager {
    
    let itemsNumber: Int
    var cursor: String?
    var hasNextPage: Bool?
    
    //MARK: - Initializers
    init(itemsNumber: Int = 10) {
        self.itemsNumber = itemsNumber
    }
}
