import Apollo

class GitHubViewerApollo {
  static let shared = GitHubViewerApollo()
  let client: ApolloClient

  init() {
    client = ApolloClient(url: Global.apiClient.baseURL)
  }
}
