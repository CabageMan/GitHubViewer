//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// Emojis that can be attached to Issues, Pull Requests and Comments.
public enum ReactionContent: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  /// Represents the `:+1:` emoji.
  case thumbsUp
  /// Represents the `:-1:` emoji.
  case thumbsDown
  /// Represents the `:laugh:` emoji.
  case laugh
  /// Represents the `:hooray:` emoji.
  case hooray
  /// Represents the `:confused:` emoji.
  case confused
  /// Represents the `:heart:` emoji.
  case heart
  /// Represents the `:rocket:` emoji.
  case rocket
  /// Represents the `:eyes:` emoji.
  case eyes
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "THUMBS_UP": self = .thumbsUp
      case "THUMBS_DOWN": self = .thumbsDown
      case "LAUGH": self = .laugh
      case "HOORAY": self = .hooray
      case "CONFUSED": self = .confused
      case "HEART": self = .heart
      case "ROCKET": self = .rocket
      case "EYES": self = .eyes
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .thumbsUp: return "THUMBS_UP"
      case .thumbsDown: return "THUMBS_DOWN"
      case .laugh: return "LAUGH"
      case .hooray: return "HOORAY"
      case .confused: return "CONFUSED"
      case .heart: return "HEART"
      case .rocket: return "ROCKET"
      case .eyes: return "EYES"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: ReactionContent, rhs: ReactionContent) -> Bool {
    switch (lhs, rhs) {
      case (.thumbsUp, .thumbsUp): return true
      case (.thumbsDown, .thumbsDown): return true
      case (.laugh, .laugh): return true
      case (.hooray, .hooray): return true
      case (.confused, .confused): return true
      case (.heart, .heart): return true
      case (.rocket, .rocket): return true
      case (.eyes, .eyes): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [ReactionContent] {
    return [
      .thumbsUp,
      .thumbsDown,
      .laugh,
      .hooray,
      .confused,
      .heart,
      .rocket,
      .eyes,
    ]
  }
}

public final class FindIssueIdQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query FindIssueID {
      repository(owner: "octocat", name: "Hello-World") {
        __typename
        issue(number: 349) {
          __typename
          id
        }
      }
    }
    """

  public let operationName = "FindIssueID"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("repository", arguments: ["owner": "octocat", "name": "Hello-World"], type: .object(Repository.selections)),
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
        GraphQLField("issue", arguments: ["number": 349], type: .object(Issue.selections)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(issue: Issue? = nil) {
        self.init(unsafeResultMap: ["__typename": "Repository", "issue": issue.flatMap { (value: Issue) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Returns a single issue from the current repository by number.
      public var issue: Issue? {
        get {
          return (resultMap["issue"] as? ResultMap).flatMap { Issue(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "issue")
        }
      }

      public struct Issue: GraphQLSelectionSet {
        public static let possibleTypes = ["Issue"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID) {
          self.init(unsafeResultMap: ["__typename": "Issue", "id": id])
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
      }
    }
  }
}

public final class AddReactionToIssueMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation AddReactionToIssue {
      addReaction(input: {subjectId: "MDU6SXNzdWUyMzEzOTE1NTE=", content: HOORAY}) {
        __typename
        reaction {
          __typename
          content
        }
        subject {
          __typename
          id
        }
      }
    }
    """

  public let operationName = "AddReactionToIssue"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("addReaction", arguments: ["input": ["subjectId": "MDU6SXNzdWUyMzEzOTE1NTE=", "content": "HOORAY"]], type: .object(AddReaction.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(addReaction: AddReaction? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "addReaction": addReaction.flatMap { (value: AddReaction) -> ResultMap in value.resultMap }])
    }

    /// Adds a reaction to a subject.
    public var addReaction: AddReaction? {
      get {
        return (resultMap["addReaction"] as? ResultMap).flatMap { AddReaction(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "addReaction")
      }
    }

    public struct AddReaction: GraphQLSelectionSet {
      public static let possibleTypes = ["AddReactionPayload"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("reaction", type: .object(Reaction.selections)),
        GraphQLField("subject", type: .object(Subject.selections)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(reaction: Reaction? = nil, subject: Subject? = nil) {
        self.init(unsafeResultMap: ["__typename": "AddReactionPayload", "reaction": reaction.flatMap { (value: Reaction) -> ResultMap in value.resultMap }, "subject": subject.flatMap { (value: Subject) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The reaction object.
      public var reaction: Reaction? {
        get {
          return (resultMap["reaction"] as? ResultMap).flatMap { Reaction(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "reaction")
        }
      }

      /// The reactable subject.
      public var subject: Subject? {
        get {
          return (resultMap["subject"] as? ResultMap).flatMap { Subject(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "subject")
        }
      }

      public struct Reaction: GraphQLSelectionSet {
        public static let possibleTypes = ["Reaction"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("content", type: .nonNull(.scalar(ReactionContent.self))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(content: ReactionContent) {
          self.init(unsafeResultMap: ["__typename": "Reaction", "content": content])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Identifies the emoji reaction.
        public var content: ReactionContent {
          get {
            return resultMap["content"]! as! ReactionContent
          }
          set {
            resultMap.updateValue(newValue, forKey: "content")
          }
        }
      }

      public struct Subject: GraphQLSelectionSet {
        public static let possibleTypes = ["PullRequest", "Issue", "TeamDiscussion", "TeamDiscussionComment", "CommitComment", "IssueComment", "PullRequestReviewComment", "PullRequestReview"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public static func makePullRequest(id: GraphQLID) -> Subject {
          return Subject(unsafeResultMap: ["__typename": "PullRequest", "id": id])
        }

        public static func makeIssue(id: GraphQLID) -> Subject {
          return Subject(unsafeResultMap: ["__typename": "Issue", "id": id])
        }

        public static func makeTeamDiscussion(id: GraphQLID) -> Subject {
          return Subject(unsafeResultMap: ["__typename": "TeamDiscussion", "id": id])
        }

        public static func makeTeamDiscussionComment(id: GraphQLID) -> Subject {
          return Subject(unsafeResultMap: ["__typename": "TeamDiscussionComment", "id": id])
        }

        public static func makeCommitComment(id: GraphQLID) -> Subject {
          return Subject(unsafeResultMap: ["__typename": "CommitComment", "id": id])
        }

        public static func makeIssueComment(id: GraphQLID) -> Subject {
          return Subject(unsafeResultMap: ["__typename": "IssueComment", "id": id])
        }

        public static func makePullRequestReviewComment(id: GraphQLID) -> Subject {
          return Subject(unsafeResultMap: ["__typename": "PullRequestReviewComment", "id": id])
        }

        public static func makePullRequestReview(id: GraphQLID) -> Subject {
          return Subject(unsafeResultMap: ["__typename": "PullRequestReview", "id": id])
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
      }
    }
  }
}
