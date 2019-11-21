import UIKit
import OAuthSwift

final class AuthVC: UIViewController {
    
    var userDidLogin: (AuthCoordinator.AuthResult) -> Void = { _ in }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupServices()
    }
    
    private func setupUI() {
        view.backgroundColor = .mainBackground
        
        let logo = UIImageView().add(to: view).then {
            $0.centerInSuperview()
            $0.size(CGSize(Theme.imageSide))
            
            $0.image = #imageLiteral(resourceName: "OctoCat")
            $0.contentMode = .scaleAspectFit
        }
        
        Buttons.roundedButton.add(to: view).do {
            $0.centerXToSuperview()
            $0.topToBottom(of: logo, offset: Theme.buttonTopOffset)
            $0.leftToSuperview(offset: Theme.buttonSideOffset)
            $0.rightToSuperview(offset: -Theme.buttonSideOffset)
            $0.setTitle(String.Auth.signIn, for: .normal)
            $0.addTarget(for: .touchUpInside) { [weak self] in self?.setupServices() }
        }
    }
    
    private func setupServices() {
        Global.apiClient.showLogin(in: self)
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
