import Apollo

class GitHubViewerApollo {
    static let shared = GitHubViewerApollo()
    private lazy var networkTransport = HTTPNetworkTransport(url: Global.apiClient.baseURL, delegate: self)
    private(set) lazy var client = ApolloClient(networkTransport: networkTransport)
}

//MARK: - Preflight Delegate Methods
extension GitHubViewerApollo: HTTPNetworkTransportPreflightDelegate {
    func networkTransport(_ networkTransport: HTTPNetworkTransport, shouldSend request: URLRequest) -> Bool {
        return Global.apiClient.isLoggedIn
    }
    
    func networkTransport(_ networkTransport: HTTPNetworkTransport, willSend request: inout URLRequest) {
        guard let token = Global.apiClient.accessToken?.token else { return }
        var headers = request.allHTTPHeaderFields ?? [String: String]()
        headers["Authorization"] = "bearer \(token)"
        request.allHTTPHeaderFields = headers
    }
}

//MARK: - Retry Delegate
extension GitHubViewerApollo: HTTPNetworkTransportRetryDelegate {
    func networkTransport(_ networkTransport: HTTPNetworkTransport, receivedError error: Error, for request: URLRequest, response: URLResponse?, retryHandler: @escaping (Bool) -> Void) {
        // Here we have to implement request retry functionality, including refresh auth token.
//        //Check if the error and/or response you've received are something that requires authentication
//        guard UserManager.shared.requiresReAuthentication(basedOn: error, response: response) else {
//          // This is not something this application can handle, do not retry.
//          retryHandler(false)
//          return
//        }
//
//        // Attempt to re-authenticate asynchronously
//        UserManager.shared.reAuthenticate { success in
//          // If re-authentication succeeded, try again. If it didn't, don't.
//          retryHandler(success)
//        }
    }
}
