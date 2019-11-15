import Apollo

class GitHubViewerApollo {
  static let shared = GitHubViewerApollo()
  let client: ApolloClient

  init() {
    client = ApolloClient(url: URL(string: "https://api.github.com/graphql")!)
  }
}
