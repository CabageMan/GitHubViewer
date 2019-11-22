//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// Ordering options for repository connections
public struct RepositoryOrder: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(field: RepositoryOrderField, direction: OrderDirection) {
    graphQLMap = ["field": field, "direction": direction]
  }

  /// The field to order repositories by.
  public var field: RepositoryOrderField {
    get {
      return graphQLMap["field"] as! RepositoryOrderField
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "field")
    }
  }

  /// The ordering direction.
  public var direction: OrderDirection {
    get {
      return graphQLMap["direction"] as! OrderDirection
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "direction")
    }
  }
}

/// Properties by which repository connections can be ordered.
public enum RepositoryOrderField: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  /// Order repositories by creation time
  case createdAt
  /// Order repositories by update time
  case updatedAt
  /// Order repositories by push time
  case pushedAt
  /// Order repositories by name
  case name
  /// Order repositories by number of stargazers
  case stargazers
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "CREATED_AT": self = .createdAt
      case "UPDATED_AT": self = .updatedAt
      case "PUSHED_AT": self = .pushedAt
      case "NAME": self = .name
      case "STARGAZERS": self = .stargazers
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .createdAt: return "CREATED_AT"
      case .updatedAt: return "UPDATED_AT"
      case .pushedAt: return "PUSHED_AT"
      case .name: return "NAME"
      case .stargazers: return "STARGAZERS"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: RepositoryOrderField, rhs: RepositoryOrderField) -> Bool {
    switch (lhs, rhs) {
      case (.createdAt, .createdAt): return true
      case (.updatedAt, .updatedAt): return true
      case (.pushedAt, .pushedAt): return true
      case (.name, .name): return true
      case (.stargazers, .stargazers): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [RepositoryOrderField] {
    return [
      .createdAt,
      .updatedAt,
      .pushedAt,
      .name,
      .stargazers,
    ]
  }
}

/// Possible directions in which to order a list of items when provided an `orderBy` argument.
public enum OrderDirection: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  /// Specifies an ascending order for a given `orderBy` argument.
  case asc
  /// Specifies a descending order for a given `orderBy` argument.
  case desc
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "ASC": self = .asc
      case "DESC": self = .desc
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .asc: return "ASC"
      case .desc: return "DESC"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: OrderDirection, rhs: OrderDirection) -> Bool {
    switch (lhs, rhs) {
      case (.asc, .asc): return true
      case (.desc, .desc): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [OrderDirection] {
    return [
      .asc,
      .desc,
    ]
  }
}

public final class GetOwnUserQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query GetOwnUser($order: RepositoryOrder!, $numberOfRepositories: Int!) {
      viewer {
        __typename
        name
        login
        repositories(last: $numberOfRepositories, orderBy: $order) {
          __typename
          totalCount
          nodes {
            __typename
            name
            id
            createdAt
          }
        }
      }
    }
    """

  public let operationName = "GetOwnUser"

  public var order: RepositoryOrder
  public var numberOfRepositories: Int

  public init(order: RepositoryOrder, numberOfRepositories: Int) {
    self.order = order
    self.numberOfRepositories = numberOfRepositories
  }

  public var variables: GraphQLMap? {
    return ["order": order, "numberOfRepositories": numberOfRepositories]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("viewer", type: .nonNull(.object(Viewer.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(viewer: Viewer) {
      self.init(unsafeResultMap: ["__typename": "Query", "viewer": viewer.resultMap])
    }

    /// The currently authenticated user.
    public var viewer: Viewer {
      get {
        return Viewer(unsafeResultMap: resultMap["viewer"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "viewer")
      }
    }

    public struct Viewer: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("name", type: .scalar(String.self)),
        GraphQLField("login", type: .nonNull(.scalar(String.self))),
        GraphQLField("repositories", arguments: ["last": GraphQLVariable("numberOfRepositories"), "orderBy": GraphQLVariable("order")], type: .nonNull(.object(Repository.selections))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(name: String? = nil, login: String, repositories: Repository) {
        self.init(unsafeResultMap: ["__typename": "User", "name": name, "login": login, "repositories": repositories.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The user's public profile name.
      public var name: String? {
        get {
          return resultMap["name"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      /// The username used to login.
      public var login: String {
        get {
          return resultMap["login"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "login")
        }
      }

      /// A list of repositories that the user owns.
      public var repositories: Repository {
        get {
          return Repository(unsafeResultMap: resultMap["repositories"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "repositories")
        }
      }

      public struct Repository: GraphQLSelectionSet {
        public static let possibleTypes = ["RepositoryConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
          GraphQLField("nodes", type: .list(.object(Node.selections))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(totalCount: Int, nodes: [Node?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "RepositoryConnection", "totalCount": totalCount, "nodes": nodes.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Identifies the total count of items in the connection.
        public var totalCount: Int {
          get {
            return resultMap["totalCount"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "totalCount")
          }
        }

        /// A list of nodes.
        public var nodes: [Node?]? {
          get {
            return (resultMap["nodes"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Node?] in value.map { (value: ResultMap?) -> Node? in value.flatMap { (value: ResultMap) -> Node in Node(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }, forKey: "nodes")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes = ["Repository"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          ]

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(name: String, id: GraphQLID, createdAt: String) {
            self.init(unsafeResultMap: ["__typename": "Repository", "name": name, "id": id, "createdAt": createdAt])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The name of the repository.
          public var name: String {
            get {
              return resultMap["name"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "name")
            }
          }

          public var id: GraphQLID {
            get {
              return resultMap["id"]! as! GraphQLID
            }
            set {
              resultMap.updateValue(newValue, forKey: "id")
            }
          }

          /// Identifies the date and time when the object was created.
          public var createdAt: String {
            get {
              return resultMap["createdAt"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "createdAt")
            }
          }
        }
      }
    }
  }
}
