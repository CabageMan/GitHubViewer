
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
    // Next
    static let next = String.tr("Localizable", "general.next")
    // Ok
    static let ok = String.tr("Localizable", "general.ok")
    // Welcome
    static let welcome = String.tr("Localizable", "general.welcome")
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

