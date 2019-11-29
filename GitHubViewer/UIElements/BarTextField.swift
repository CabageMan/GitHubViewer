import UIKit

final class BarTextField: NSObject {
    
    struct ReturnKeyAction {
        let button: UIReturnKeyType
        let block: () -> Void
    }
    
    //MARK: - Public Properties
    var placeHolder: String? {
        get { return textField.placeholder }
        set { textField.placeholder = newValue }
    }
    
    var value: String? {
        get { return textField.text }
        set { textField.text = newValue }
    }
    
    var returnKeyAction: ReturnKeyAction? {
      didSet {
        if let action = returnKeyAction {
          textField.returnKeyType = action.button
        }
      }
    }
    
    //MARK: - Elements
    let textField = UITextField()
    
    //MARK: - Events
    var valueChanged: (String) -> Void = { _ in }
    var onReturnPressed: (String) -> Void = { _ in }
    
    //MARK: - Initializers
    override init() {
        super.init()
        setup()
    }
    
    //MARK: - Actions
    private func setup() {
        textField.do { field in
            field.font = Theme.textFieldFont
            field.textColor = .white
            field.tintColor = .white
            field.backgroundColor = .barFieldBackGround
            field.layer.cornerRadius = .defaultCornerRadius
            field.addTarget(for: .valueChanged) { [weak self] in self?.valueChanged(field.text ?? "") }
            field.addTarget(for: .editingDidBegin) { [weak self] in self?.beginEditing() }
            field.addTarget(for: .editingDidEnd) { [weak self] in self?.endEditing() }
            field.addTarget(for: .editingDidEndOnExit) { [weak self] in self?.endEditingOnExit() }
        }
    }
    
    private func beginEditing() {
        textField.do {
            $0.backgroundColor = .white
            $0.textColor = .barBlack
            $0.tintColor = .barBlack
        }
    }
    
    private func endEditing() {
        textField.do {
            $0.backgroundColor = .barFieldBackGround
            $0.textColor = .white
            $0.tintColor = .white
        }
    }
    
    private func endEditingOnExit() {
        onReturnPressed(textField.text ?? "")
    }
}

//MARK: - Templates
extension BarTextField {
    static func createRepoSearchField() -> BarTextField {
        return BarTextField().then {
            $0.textField.returnKeyType = .search
            $0.textField.autocorrectionType = .no
            $0.textField.autocapitalizationType = .none
            $0.textField.spellCheckingType = .no
            $0.placeHolder = String.Repos.findRepository
            $0.textField.attributedPlaceholder = NSAttributedString(string: String.Repos.findRepository,
            attributes: [.foregroundColor: UIColor.barFieldPlaceHolder])
            let container = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 30.0, height: 30.0))
            let searchIcon = #imageLiteral(resourceName: "searchLeft20")
            UIImageView(image: searchIcon.withRenderingMode(.alwaysTemplate)).add(to: container).do {
                $0.frame = CGRect(x: 5.0, y: 5.0, width: 20.0, height: 20.0)
            }
            $0.textField.leftView = container
            $0.textField.leftViewMode = .always
        }
    }
}

//MARK: - Theme
extension BarTextField {
    enum Theme {
        // Fonts
        static let textFieldFont: UIFont = .circular(style: .book, size: 13)
        
        // Sizes
    }
}
