import UIKit

final class IntroVC: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    //MARK: -Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func setup() {
        let logo = UIImageView().add(to: view).then {
            $0.centerInSuperview()
            $0.width(Theme.imageSide)
            $0.height(Theme.imageSide)
            
            $0.image = #imageLiteral(resourceName: "OctoCat")
            $0.contentMode = .scaleAspectFit
        }
        
        UILabel().add(to: view).do {
            $0.centerXToSuperview()
            $0.bottomToTop(of: logo, offset: -Theme.titleOffset)
            $0.widthToSuperview()
            $0.height(Theme.titleHeight)
            
            $0.text = String.Auth.welcome
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.font = Theme.titleFont
            $0.textColor = .darkCoal
        }
        
        Buttons.roundedButton.add(to: view).do {
            $0.centerXToSuperview()
            $0.topToBottom(of: logo, offset: Theme.titleOffset)
            $0.leftToSuperview(offset: Theme.buttonSideOffset)
            $0.rightToSuperview(offset: -Theme.buttonSideOffset)
            $0.setTitle(String.General.next, for: .normal)
            $0.addTarget(for: .touchUpInside) { [weak self] in
                self?.nextButtonTap()
            }
        }
    }
    
    //MARK: -Actions
    private func nextButtonTap() {
        Global.showComingSoon()
    }
}

extension IntroVC {
    enum Theme {
        // Fonts
        static let titleFont: UIFont = .cf(style: .compactDisplayThin, size: 30.0)
        // Colors
        
        // Sizes
        static let imageSide: CGFloat = UIScreen.main.bounds.width
        static let titleHeight: CGFloat = 75.0
        static let nextButtonWidth: CGFloat = 137.0
        
        // Offsets
        static let buttonSideOffset: CGFloat = 90.0
        static var titleOffset: CGFloat {
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
