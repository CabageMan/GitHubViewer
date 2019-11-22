import UIKit

final class AuthVCOld: UIViewController {
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainBackground
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func setupUI() {
        let container = UIStackView().add(to: view).then {
            $0.leftToSuperview(offset: Theme.containerSideOffset)
            $0.rightToSuperview(offset: -Theme.containerSideOffset)
            $0.topToSuperview(offset: .safeTop + 10.0)
            
            $0.axis = .vertical
            $0.alignment = .center
            $0.distribution = .equalSpacing
            $0.spacing = Theme.spacing
        }
        
        UIImageView().add(to: container).do {
            $0.size(CGSize(Theme.logoSide))
            $0.image = #imageLiteral(resourceName: "OctoCat")
            $0.contentMode = .scaleAspectFit
        }
        
        container.addSpace(height: 15)
        
        UILabel().add(to: container).do {
            $0.widthToSuperview()
            $0.height(Theme.titleHeight)
            
            $0.textAlignment = .center
            $0.font = Theme.titleFont
            $0.textColor = .darkCoal
            $0.text = String.Auth.signInToGithub
        }
        
        container.addSpace(height: 15)
        
        let fieldsView = UIView().add(to: container).then {
            $0.widthToSuperview()
            $0.height(Theme.fieldsContainerHeight)
            
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = UIColor.fieldBorderColor.cgColor
            $0.layer.cornerRadius = .defaultCornerRadius
            $0.backgroundColor = .white
        }
        
        let fieldsContainer = UIStackView().add(to: fieldsView).then {
            $0.edgesToSuperview(excluding: [.left, .right])
            $0.leftToSuperview(offset: Theme.textFieldSideOffset)
            $0.rightToSuperview(offset: -Theme.textFieldSideOffset)
            $0.axis = .vertical
            $0.alignment = .center
            $0.distribution = .equalSpacing
            $0.spacing = Theme.spacing
        }
        
        fieldsContainer.addSpace(height: 10.0)
        
        TitledTextField.createUserNameField(title: String.Auth.usernameOrEmail).add(to: fieldsContainer).do {
            $0.widthToSuperview()
        }
        
        TitledTextField.createPasswordField(title: String.Auth.password).add(to: fieldsContainer).do {
            $0.widthToSuperview()
            $0.setTitleButton(with: String.Auth.forgotPassword) {
                Global.showComingSoon()
            }
        }
        fieldsContainer.addSpace(height: 10.0)
        
        Buttons.roundedButton.add(to: fieldsContainer).do {
            $0.widthToSuperview()
            $0.setTitle(String.Auth.signIn, for: .normal)
            $0.addTarget(for: .touchUpInside) { Global.showComingSoon() }
        }
        
        fieldsContainer.addSpace(height: 10.0)
        
        Buttons.roundedButton.add(to: container).do {
            $0.widthToSuperview()
            $0.setTitle(String.Auth.newToGithub, for: .normal)
            $0.addTarget(for: .touchUpInside) { [weak self] in self?.onCreateAccountTap() }
            
            $0.layer.borderColor = UIColor.fieldBorderColor.cgColor
            $0.backgroundColor = .mainBackground
            $0.setTitleColor(.darkCoal, for: .normal)
            $0.titleLabel?.font = Theme.createAccountButtonFont
        }
    }
}

//MARK: - Actions
extension AuthVCOld {
    private func findIssue() {
//        GitHubViewerApollo.shared.client.fetch(query: FindIssueIdQuery()) { result in
//            log("Result: \(result)")
//        }
    }
    
    private func onCreateAccountTap() {
        Global.showComingSoon()
    }
}

//MARK: - Theme
extension AuthVCOld {
    enum Theme {
        // Fonts
        static let titleFont: UIFont = .cf(style: .compactDisplayThin, size: 23.0)
        static let createAccountButtonFont: UIFont = .circular(style: .book, size: 16)
        
        // Sizes
        static let logoSide: CGFloat = 60.0
        static let titleHeight: CGFloat = 25.0
        static let fieldsContainerHeight: CGFloat = 230.0
        
        // Offsets
        static let containerSideOffset: CGFloat = 30.0
        static let textFieldSideOffset: CGFloat = 20.0
        static var spacing: CGFloat = 5.0
    }
}
