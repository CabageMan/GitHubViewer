import UIKit
import WebKit
import OAuthSwift

final class WebViewController: OAuthWebViewController {
    
    let webView = WKWebView()
    var webViewBottomConstraint: NSLayoutConstraint!
    
    var targetUrl: URL?
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loaadAddressURL()
    }
    
    private func setupUI() {
        webView.add(to: view).do {
            $0.edgesToSuperview(excluding: .bottom)
            webViewBottomConstraint = $0.bottomToSuperview()
            $0.navigationDelegate = self
        }
    }
    
    //MARK: - Actions
    override func handle(_ url: URL) {
        self.targetUrl = url
        super.handle(url)
        loaadAddressURL()
    }
    
    func loaadAddressURL() {
        guard let url = targetUrl else { return }
        let request = URLRequest(url: url)
        DispatchQueue.main.async { [weak self] in
            self?.webView.load(request)
        }
    }
    
    static func clean(completion: @escaping () -> Void) {
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
          dataStore.removeData(
            ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(),
            for: records.filter { $0.displayName.contains("github") },
            completionHandler: completion
          )
        }
    }
}

//MARK: - Web View Navigation Delegate Methods
extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, url.scheme == Environment.scheme {
            AppDelegate.shared.applicationHandle(url: url)
            decisionHandler(.cancel)
            dismissWebViewController()
            return
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Spinner.stop()
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        Spinner.start()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Spinner.stop()
        dismissWebViewController()
        Global.apiClient.cancelAuthRequest()
    }
}
