
import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
extension String {

  enum Auth {
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

