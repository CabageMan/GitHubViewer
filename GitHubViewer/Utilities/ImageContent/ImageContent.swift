import UIKit

enum ImageContent: Hashable, Codable {
    case image(String)
    case url(URL)
    
    static var avatarPlaceholder = ImageContent.image("AvatarPlaceholder")
    
    var path: String {
        switch self {
        case .image(let name): return name
        case .url(let url): return url.absoluteString
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let path: String = try container.decode(String.self)
        if UIImage(named: path) != nil {
            self = .image(path)
        } else if let url = URL(string: path) {
            self = .url(url)
        } else {
            if UIImage(named: ImageContent.avatarPlaceholder.path) != nil {
                self = ImageContent.avatarPlaceholder
            } else {
                throw SimpleError("Incorrect image content type")
            }
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(path)
    }
}
