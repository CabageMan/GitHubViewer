import UIKit
import OAuthSwift

final class AuthVC: UIViewController {
    
    var userDidLogin: (AuthCoordinator.AuthResult) -> Void = { _ in }
    
    private let keyboardObserver = KeyboardObserver()
    
    lazy var webViewController: WebViewController = {
        return WebViewController().then {
            $0.view = UIView(frame: UIScreen.main.bounds)
            $0.delegate = self
            $0.viewDidLoad()
        }
    }()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupServices()
    }
    
    private func setupUI() {
        view.backgroundColor = .mainBackground
    }
    
    private func setupServices() {
        // Use SafariURLHandler
//        Global.apiClient.showLogin(in: self)
        
        // Use WKWebView
        Global.apiClient.showLogin(with: getURLHandler()) { [weak self] isAuthorized in
            self?.userDidLogin(isAuthorized ? .success : .failure)
        }
        
        // There is the issue with constraints when keyboard appears on field edit:
        // https://stackoverflow.com/a/51475732
        keyboardObserver.observe { event in
            UIView.animate(
                withDuration: event.duration,
                delay: 0,
                options: event.options,
                animations: { [weak self] in
                    let inset = UIScreen.main.bounds.height - event.keyboardFrameEnd.minY
                    self?.webViewController.webViewBottomConstraint.constant = -inset
                }
            )
        }
    }
    
    func getURLHandler() -> OAuthSwiftURLHandlerType {
        if webViewController.parent == nil {
            addChild(webViewController)
        }
        return webViewController
    }
}

extension AuthVC: OAuthWebViewControllerDelegate {
    func oauthWebViewControllerDidPresent() {
        log("Web View Controller  Did Present")
    }
    
    func oauthWebViewControllerDidDismiss() {
        log("Web View Controller  Did Dismiss")
    }
    
    func oauthWebViewControllerWillAppear() {
        log("Web View Controller  Will Appear")
    }
    
    func oauthWebViewControllerDidAppear() {
        log("Web View Controller  Did Appear")
    }
    
    func oauthWebViewControllerWillDisappear() {
        log("Web View Controller  Will Disappear")
    }
    
    func oauthWebViewControllerDidDisappear() {
        webViewController.remove()
    }
}
