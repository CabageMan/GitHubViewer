import UIKit
import OAuthSwift

final class AuthVC: UIViewController {
    
    var userDidLogin: (AuthCoordinator.AuthResult) -> Void = { _ in }
    
    private let keyboardObserver = KeyboardObserver()
    
//    private var webViewController: WebViewController?
    
    lazy var webViewController: WebViewController = {
        let controller = WebViewController()
        controller.view = UIView(frame: UIScreen.main.bounds)
        controller.delegate = self
        controller.viewDidLoad()
        return controller
    }()
    
    private var webViewBottomConstraint: NSLayoutConstraint!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupServices()
        #warning("Add keyboard observer")
    }
    
    private func setupUI() {
        view.backgroundColor = .mainBackground
        
//        let logo = UIImageView().add(to: view).then {
//            $0.centerInSuperview()
//            $0.size(CGSize(Theme.imageSide))
//            
//            $0.image = #imageLiteral(resourceName: "OctoCatColored")
//            $0.contentMode = .scaleAspectFit
//        }
//        
//        Buttons.roundedButton.add(to: view).do {
//            $0.centerXToSuperview()
//            $0.topToBottom(of: logo, offset: Theme.buttonTopOffset)
//            $0.leftToSuperview(offset: Theme.buttonSideOffset)
//            $0.rightToSuperview(offset: -Theme.buttonSideOffset)
//            $0.setTitle(String.Auth.signIn, for: .normal)
//            $0.addTarget(for: .touchUpInside) { [weak self] in self?.setupServices() }
//        }
    }
    
    private func setupServices() {
        // Use SafariURLHandler
//        Global.apiClient.showLogin(in: self)
        
        // Use WKWebView
        if webViewController.parent == nil {
            add(webViewController)
        }
        Global.apiClient.showLogin(in: webViewController) { [weak self] isAuthorized in
            self?.userDidLogin(isAuthorized ? .success : .failure)
        }
        
//        WebViewController().do {
//            self.add($0)
//            Global.apiClient.showLogin(in: $0) { [weak self] isAuthorized in
//                self?.userDidLogin(isAuthorized ? .success : .failure)
//            }
//            webViewController = $0
//            $0.view.add(to: self.view).do {
//                $0.edgesToSuperview(excluding: .bottom)
//                self.webViewBottomConstraint = $0.bottomToSuperview()
//            }
//        }
//        keyboardObserver.observe { event in
//            UIView.animate(
//                withDuration: event.duration,
//                delay: 0,
//                options: event.options,
//                animations: { [weak self] in
//                    let inset = UIScreen.main.bounds.height - event.keyboardFrameEnd.minY
//                    self?.webViewBottomConstraint.constant = -inset
//                }
//            )
//        }
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
        log("Web View Controller  Did Disappear")
        // Ensure all listeners are removed if presented web view close
    }
}

//MARK: - Theme
extension AuthVC {
    enum Theme {
        // Sizes
        static let imageSide: CGFloat = UIScreen.main.bounds.width
        
        // Offsets
        static let buttonSideOffset: CGFloat = 90.0
        static var buttonTopOffset: CGFloat {
            switch Device.realDiagonal {
            case Device.iPhone5.diagonal: return 15.0
            case Device.iPhone6.diagonal: return 27.5
            case Device.iPhone6Plus.diagonal: return 35.0
            case Device.iPhoneX.diagonal: return 57.0
            case Device.iPhoneXr.diagonal: return 66.0
            case Device.iPhoneXsMax.diagonal: return 68.0
            default: return 15.0
            }
        }
    }
}
