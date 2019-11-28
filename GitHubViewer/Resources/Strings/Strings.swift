
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

  enum General {
    // Cancel
    static let cancel = String.tr("Localizable", "general.cancel")
    // Coming soon ...
    static let comingSoon = String.tr("Localizable", "general.coming_soon")
    // Copy link to clipBoard
    static let copyLink = String.tr("Localizable", "general.copyLink")
    // Next
    static let next = String.tr("Localizable", "general.next")
    // Ok
    static let ok = String.tr("Localizable", "general.ok")
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
    // Pull Requests
    static let title = String.tr("Localizable", "pr.title")
  }

  enum Profile {
    // Profile
    static let title = String.tr("Localizable", "profile.title")
  }

  enum Repos {
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
    // Repositories
    static let title = String.tr("Localizable", "repos.title")
    // Updated At
    static let updatedAt = String.tr("Localizable", "repos.updatedAt")
    // Repository URL
    static let url = String.tr("Localizable", "repos.url")
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

