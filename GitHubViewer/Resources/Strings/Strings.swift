
import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
extension String {

  enum Auth {
    // Contact GitHub
    static let contactGithub = String.tr("Localizable", "auth.contact_github")
    // Forgot Password
    static let forgotPassword = String.tr("Localizable", "auth.forgot_password")
    // New to GitHub? Create an account.
    static let newToGithub = String.tr("Localizable", "auth.new_to_github")
    // Password
    static let password = String.tr("Localizable", "auth.password")
    // Privacy
    static let privacy = String.tr("Localizable", "auth.privacy")
    // Security
    static let security = String.tr("Localizable", "auth.security")
    // Sign in
    static let signIn = String.tr("Localizable", "auth.sign_in")
    // Sign in to GitHub
    static let signInToGithub = String.tr("Localizable", "auth.sign_in_to_github")
    // Terms
    static let terms = String.tr("Localizable", "auth.terms")
    // Username or email address
    static let usernameOrEmail = String.tr("Localizable", "auth.username_or_email")
    // Welcome to\nGitHubViewer
    static let welcome = String.tr("Localizable", "auth.welcome")
  }

  enum EmptyView {
    // Your issues will be displayed here
    static let emptyIssues = String.tr("Localizable", "emptyView.emptyIssues")
    // Your profile will be displayed here
    static let emptyProfile = String.tr("Localizable", "emptyView.emptyProfile")
    // Your pull requests will be displayed here
    static let emptyPullRequests = String.tr("Localizable", "emptyView.emptyPullRequests")
    // Your repositories will be\ndisplayed here
    static let emptyRepositories = String.tr("Localizable", "emptyView.emptyRepositories")
    // There is no details
    static let emptyRepositoryDetails = String.tr("Localizable", "emptyView.emptyRepositoryDetails")
  }

  enum Fake {
    // First menu item
    static let firstMenuItem = String.tr("Localizable", "fake.firstMenuItem")
    // Second menu item
    static let secondMenuItem = String.tr("Localizable", "fake.secondMenuItem")
    // Third menu item
    static let thirdMenuItem = String.tr("Localizable", "fake.thirdMenuItem")
    // Now you can use this link anywhere you want
    static let useLinkAnywhere = String.tr("Localizable", "fake.useLinkAnywhere")
  }

  enum General {
    // Cancel
    static let cancel = String.tr("Localizable", "general.cancel")
    // Closed
    static let closed = String.tr("Localizable", "general.closed")
    // Coming soon ...
    static let comingSoon = String.tr("Localizable", "general.coming_soon")
    // Copy link to clipBoard
    static let copyLink = String.tr("Localizable", "general.copyLink")
    // Link copied to\nclipboard
    static let linkCopied = String.tr("Localizable", "general.linkCopied")
    // Next
    static let next = String.tr("Localizable", "general.next")
    // Ok
    static let ok = String.tr("Localizable", "general.ok")
    // Open
    static let `open` = String.tr("Localizable", "general.open")
    // Open link in Safari
    static let openLink = String.tr("Localizable", "general.openLink")
    // Welcome
    static let welcome = String.tr("Localizable", "general.welcome")
  }

  enum Issues {
    // Issues
    static let title = String.tr("Localizable", "issues.title")
  }

  enum Pr {
    // Assigned
    static let assigned = String.tr("Localizable", "pr.assigned")
    // Created
    static let created = String.tr("Localizable", "pr.created")
    // Mentioned
    static let mentioned = String.tr("Localizable", "pr.mentioned")
    // #%@ opened %@ ago by %@
    static func openedRequest(_ p1: String, _ p2: String, _ p3: String) -> String {
      return String.tr("Localizable", "pr.openedRequest", p1, p2, p3)
    }
    // #%@ by %@
    static func requestByAuthor(_ p1: String, _ p2: String) -> String {
      return String.tr("Localizable", "pr.requestByAuthor", p1, p2)
    }
    // Review Requests
    static let reviewRequests = String.tr("Localizable", "pr.reviewRequests")
    // Pull Requests
    static let title = String.tr("Localizable", "pr.title")
    //  was closed %@ ago
    static func wasClosed(_ p1: String) -> String {
      return String.tr("Localizable", "pr.wasClosed", p1)
    }
    //  was merged %@ ago
    static func wasMerged(_ p1: String) -> String {
      return String.tr("Localizable", "pr.wasMerged", p1)
    }
  }

  enum Profile {
    // Profile
    static let title = String.tr("Localizable", "profile.title")
  }

  enum Repos {
    // Assignable Users
    static let assignableUsers = String.tr("Localizable", "repos.assignableUsers")
    // Collaborators
    static let collaborators = String.tr("Localizable", "repos.collaborators")
    // Created At
    static let createdAt = String.tr("Localizable", "repos.createdAt")
    // Description
    static let descriprion = String.tr("Localizable", "repos.descriprion")
    // Find a repository...
    static let findRepository = String.tr("Localizable", "repos.findRepository")
    // Forrk Count
    static let forkCount = String.tr("Localizable", "repos.forkCount")
    // Parent
    static let parent = String.tr("Localizable", "repos.parent")
    // Pushed At
    static let pushedAt = String.tr("Localizable", "repos.pushedAt")
    // Repository Details
    static let repositoryDetails = String.tr("Localizable", "repos.repositoryDetails")
    // Repository Info
    static let repositoryInfo = String.tr("Localizable", "repos.repositoryInfo")
    // Repositories
    static let title = String.tr("Localizable", "repos.title")
    // Updated At
    static let updatedAt = String.tr("Localizable", "repos.updatedAt")
    // Repository URL
    static let url = String.tr("Localizable", "repos.url")
    // Watchers
    static let watchers = String.tr("Localizable", "repos.watchers")
  }

  enum SideMenu {
    // Sign out
    static let logout = String.tr("Localizable", "sideMenu.logout")
    // Settings
    static let settings = String.tr("Localizable", "sideMenu.settings")
    // Signed in as
    static let signedInAs = String.tr("Localizable", "sideMenu.signedInAs")
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length nesting type_body_length type_name

extension String {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}

