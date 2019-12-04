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

public final class OwnUserQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query OwnUser($order: RepositoryOrder!, $numberOfRepositories: Int!) {
      viewer {
        __typename
        ...UserFragment
      }
    }
    """

  public let operationName = "OwnUser"

  public var queryDocument: String { return operationDefinition.appending(UserFragment.fragmentDefinition).appending(RepositoriesListFragment.fragmentDefinition) }

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
        GraphQLFragmentSpread(UserFragment.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var userFragment: UserFragment {
          get {
            return UserFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class RepositoryDetailsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query RepositoryDetails($ownerLogin: String!, $repositoryName: String!, $order: RepositoryOrder!, $numberOfRepositories: Int!) {
      repository(owner: $ownerLogin, name: $repositoryName) {
        __typename
        ...RepositoryDetailsFragment
      }
    }
    """

  public let operationName = "RepositoryDetails"

  public var queryDocument: String { return operationDefinition.appending(RepositoryDetailsFragment.fragmentDefinition).appending(UserFragment.fragmentDefinition).appending(RepositoriesListFragment.fragmentDefinition) }

  public var ownerLogin: String
  public var repositoryName: String
  public var order: RepositoryOrder
  public var numberOfRepositories: Int

  public init(ownerLogin: String, repositoryName: String, order: RepositoryOrder, numberOfRepositories: Int) {
    self.ownerLogin = ownerLogin
    self.repositoryName = repositoryName
    self.order = order
    self.numberOfRepositories = numberOfRepositories
  }

  public var variables: GraphQLMap? {
    return ["ownerLogin": ownerLogin, "repositoryName": repositoryName, "order": order, "numberOfRepositories": numberOfRepositories]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("repository", arguments: ["owner": GraphQLVariable("ownerLogin"), "name": GraphQLVariable("repositoryName")], type: .object(Repository.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(repository: Repository? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "repository": repository.flatMap { (value: Repository) -> ResultMap in value.resultMap }])
    }

    /// Lookup a given repository by the owner and repository name.
    public var repository: Repository? {
      get {
        return (resultMap["repository"] as? ResultMap).flatMap { Repository(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "repository")
      }
    }

    public struct Repository: GraphQLSelectionSet {
      public static let possibleTypes = ["Repository"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(RepositoryDetailsFragment.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var repositoryDetailsFragment: RepositoryDetailsFragment {
          get {
            return RepositoryDetailsFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class FindRepositoryQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query FindRepository($ownerLogin: String!, $repositoryName: String!) {
      repository(owner: $ownerLogin, name: $repositoryName) {
        __typename
        ...RepositoriesListFragment
      }
    }
    """

  public let operationName = "FindRepository"

  public var queryDocument: String { return operationDefinition.appending(RepositoriesListFragment.fragmentDefinition) }

  public var ownerLogin: String
  public var repositoryName: String

  public init(ownerLogin: String, repositoryName: String) {
    self.ownerLogin = ownerLogin
    self.repositoryName = repositoryName
  }

  public var variables: GraphQLMap? {
    return ["ownerLogin": ownerLogin, "repositoryName": repositoryName]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("repository", arguments: ["owner": GraphQLVariable("ownerLogin"), "name": GraphQLVariable("repositoryName")], type: .object(Repository.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(repository: Repository? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "repository": repository.flatMap { (value: Repository) -> ResultMap in value.resultMap }])
    }

    /// Lookup a given repository by the owner and repository name.
    public var repository: Repository? {
      get {
        return (resultMap["repository"] as? ResultMap).flatMap { Repository(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "repository")
      }
    }

    public struct Repository: GraphQLSelectionSet {
      public static let possibleTypes = ["Repository"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(RepositoriesListFragment.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var repositoriesListFragment: RepositoriesListFragment {
          get {
            return RepositoriesListFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public struct UserFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition =
    """
    fragment UserFragment on User {
      __typename
      name
      login
      avatarUrl
      repositories(last: $numberOfRepositories, orderBy: $order) {
        __typename
        totalCount
        nodes {
          __typename
          ...RepositoriesListFragment
        }
      }
    }
    """

  public static let possibleTypes = ["User"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("name", type: .scalar(String.self)),
    GraphQLField("login", type: .nonNull(.scalar(String.self))),
    GraphQLField("avatarUrl", type: .nonNull(.scalar(String.self))),
    GraphQLField("repositories", arguments: ["last": GraphQLVariable("numberOfRepositories"), "orderBy": GraphQLVariable("order")], type: .nonNull(.object(Repository.selections))),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(name: String? = nil, login: String, avatarUrl: String, repositories: Repository) {
    self.init(unsafeResultMap: ["__typename": "User", "name": name, "login": login, "avatarUrl": avatarUrl, "repositories": repositories.resultMap])
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

  /// A URL pointing to the user's public avatar.
  public var avatarUrl: String {
    get {
      return resultMap["avatarUrl"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "avatarUrl")
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
        GraphQLFragmentSpread(RepositoriesListFragment.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var repositoriesListFragment: RepositoriesListFragment {
          get {
            return RepositoriesListFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public struct RepositoriesListFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition =
    """
    fragment RepositoriesListFragment on Repository {
      __typename
      id
      name
      createdAt
      resourcePath
      isPrivate
      isFork
      description
      primaryLanguage {
        __typename
        name
        color
      }
    }
    """

  public static let possibleTypes = ["Repository"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
    GraphQLField("name", type: .nonNull(.scalar(String.self))),
    GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
    GraphQLField("resourcePath", type: .nonNull(.scalar(String.self))),
    GraphQLField("isPrivate", type: .nonNull(.scalar(Bool.self))),
    GraphQLField("isFork", type: .nonNull(.scalar(Bool.self))),
    GraphQLField("description", type: .scalar(String.self)),
    GraphQLField("primaryLanguage", type: .object(PrimaryLanguage.selections)),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, name: String, createdAt: String, resourcePath: String, isPrivate: Bool, isFork: Bool, description: String? = nil, primaryLanguage: PrimaryLanguage? = nil) {
    self.init(unsafeResultMap: ["__typename": "Repository", "id": id, "name": name, "createdAt": createdAt, "resourcePath": resourcePath, "isPrivate": isPrivate, "isFork": isFork, "description": description, "primaryLanguage": primaryLanguage.flatMap { (value: PrimaryLanguage) -> ResultMap in value.resultMap }])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
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

  /// The name of the repository.
  public var name: String {
    get {
      return resultMap["name"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "name")
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

  /// The HTTP path for this repository
  public var resourcePath: String {
    get {
      return resultMap["resourcePath"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "resourcePath")
    }
  }

  /// Identifies if the repository is private.
  public var isPrivate: Bool {
    get {
      return resultMap["isPrivate"]! as! Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "isPrivate")
    }
  }

  /// Identifies if the repository is a fork.
  public var isFork: Bool {
    get {
      return resultMap["isFork"]! as! Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "isFork")
    }
  }

  /// The description of the repository.
  public var description: String? {
    get {
      return resultMap["description"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "description")
    }
  }

  /// The primary language of the repository's code.
  public var primaryLanguage: PrimaryLanguage? {
    get {
      return (resultMap["primaryLanguage"] as? ResultMap).flatMap { PrimaryLanguage(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "primaryLanguage")
    }
  }

  public struct PrimaryLanguage: GraphQLSelectionSet {
    public static let possibleTypes = ["Language"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("name", type: .nonNull(.scalar(String.self))),
      GraphQLField("color", type: .scalar(String.self)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(name: String, color: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "Language", "name": name, "color": color])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    /// The name of the current language.
    public var name: String {
      get {
        return resultMap["name"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "name")
      }
    }

    /// The color defined for the current language.
    public var color: String? {
      get {
        return resultMap["color"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "color")
      }
    }
  }
}

public struct RepositoryDetailsFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition =
    """
    fragment RepositoryDetailsFragment on Repository {
      __typename
      pushedAt
      url
      updatedAt
      forkCount
      parent {
        __typename
        name
      }
      assignableUsers(first: 13) {
        __typename
        nodes {
          __typename
          ...UserFragment
        }
      }
    }
    """

  public static let possibleTypes = ["Repository"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("pushedAt", type: .scalar(String.self)),
    GraphQLField("url", type: .nonNull(.scalar(String.self))),
    GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
    GraphQLField("forkCount", type: .nonNull(.scalar(Int.self))),
    GraphQLField("parent", type: .object(Parent.selections)),
    GraphQLField("assignableUsers", arguments: ["first": 13], type: .nonNull(.object(AssignableUser.selections))),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(pushedAt: String? = nil, url: String, updatedAt: String, forkCount: Int, parent: Parent? = nil, assignableUsers: AssignableUser) {
    self.init(unsafeResultMap: ["__typename": "Repository", "pushedAt": pushedAt, "url": url, "updatedAt": updatedAt, "forkCount": forkCount, "parent": parent.flatMap { (value: Parent) -> ResultMap in value.resultMap }, "assignableUsers": assignableUsers.resultMap])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  /// Identifies when the repository was last pushed to.
  public var pushedAt: String? {
    get {
      return resultMap["pushedAt"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "pushedAt")
    }
  }

  /// The HTTP URL for this repository
  public var url: String {
    get {
      return resultMap["url"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "url")
    }
  }

  /// Identifies the date and time when the object was last updated.
  public var updatedAt: String {
    get {
      return resultMap["updatedAt"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  /// Returns how many forks there are of this repository in the whole network.
  public var forkCount: Int {
    get {
      return resultMap["forkCount"]! as! Int
    }
    set {
      resultMap.updateValue(newValue, forKey: "forkCount")
    }
  }

  /// The repository parent, if this is a fork.
  public var parent: Parent? {
    get {
      return (resultMap["parent"] as? ResultMap).flatMap { Parent(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "parent")
    }
  }

  /// A list of users that can be assigned to issues in this repository.
  public var assignableUsers: AssignableUser {
    get {
      return AssignableUser(unsafeResultMap: resultMap["assignableUsers"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "assignableUsers")
    }
  }

  public struct Parent: GraphQLSelectionSet {
    public static let possibleTypes = ["Repository"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("name", type: .nonNull(.scalar(String.self))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(name: String) {
      self.init(unsafeResultMap: ["__typename": "Repository", "name": name])
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
  }

  public struct AssignableUser: GraphQLSelectionSet {
    public static let possibleTypes = ["UserConnection"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("nodes", type: .list(.object(Node.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(nodes: [Node?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "UserConnection", "nodes": nodes.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
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
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(UserFragment.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var userFragment: UserFragment {
          get {
            return UserFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}
