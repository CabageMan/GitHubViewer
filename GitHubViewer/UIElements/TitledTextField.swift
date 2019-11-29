import UIKit

final class TitledTextField: UIView {
    
    struct ReturnKeyAction {
        let button: UIReturnKeyType
        let block: () -> Void
    }
    
    //MARK: - Public Properties
    var title: String {
        get { return titleLabel.text ?? "" }
        set { titleLabel.text = newValue }
    }
    
    var placeHolder: String? {
        get { return textField.placeholder }
        set { textField.placeholder = newValue }
    }
    
    var value: String? {
        get { return textField.text }
        set { textField.text = newValue }
    }
    
    var titleButton: UIButton?
    
    var returnKeyAction: ReturnKeyAction? {
      didSet {
        if let action = returnKeyAction {
          textField.returnKeyType = action.button
        }
      }
    }
    
    //MARK: - Events
    var valueChanged: (String) -> Void = { _ in }
    var onReturnPressed: (String) -> Void = { _ in }
    
    //MARK: - Elements
    let textField: UITextField
    private let titleLabel = UILabel()
    private let shadowView = UIView()
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        textField = UITextField()
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        textField = UITextField()
        super.init(coder: coder)
        setup()
    }
    
    //MARK: - Actions
    private func setup() {
        height(Theme.mainheight)
        
        titleLabel.add(to: self).do {
            $0.edgesToSuperview(excluding: [.left, .bottom])
            $0.leftToSuperview(offset: Theme.contentSideOffset)
            $0.height(Theme.titleLabelHeight)
            
            $0.font = Theme.titleLabelFont
            $0.textColor = .darkCoal
            $0.textAlignment = .left
        }
        
        shadowView.add(to: self).do {
            $0.edgesToSuperview(excluding: [.top, .bottom])
            $0.topToBottom(of: titleLabel, offset: Theme.fieldTopOffset)
            $0.height(Theme.textfieldHeight)
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = Theme.shadowCornerRadius
        }
        
        textField.add(to: shadowView).do { field in
            field.topToSuperview(offset: Theme.contentSideOffset)
            field.leftToSuperview(offset: Theme.contentSideOffset)
            field.rightToSuperview(offset: -Theme.contentSideOffset)
            field.bottomToSuperview(offset: -Theme.contentSideOffset)
            
            field.font = Theme.textFieldFont
            field.textColor = .darkCoal
            field.tintColor = .darkCoal
            field.backgroundColor = .fieldBackground
            field.layer.borderWidth = Theme.borderWidth
            field.layer.cornerRadius = .defaultCornerRadius
            field.layer.borderColor = UIColor.fieldBorderColor.cgColor
            field.addTarget(for: .valueChanged) { [weak self] in self?.valueChanged(field.text ?? "") }
            field.addTarget(for: .editingDidBegin) { [weak self] in self?.beginEditing() }
            field.addTarget(for: .editingDidEnd) { [weak self] in self?.endEditing() }
            field.addTarget(for: .editingDidEndOnExit) { [weak self] in self?.endEditingOnExit() }
        }
    }
    
    private func beginEditing() {
        textField.layer.borderColor = UIColor.selectedFieldBorder.cgColor
        shadowView.backgroundColor = .selectedFieldShadow
    }
    
    private func endEditing() {
        textField.layer.borderColor = UIColor.fieldBorderColor.cgColor
        shadowView.backgroundColor = .clear
    }
    
    private func endEditingOnExit() {
        onReturnPressed(textField.text ?? "")
    }
}

//MARK: - Public Actions
extension TitledTextField {
    func setTitleButton(with tittle: String, action: @escaping () -> Void) {
        titleButton = UIButton().add(to: self).then {
            $0.edgesToSuperview(excluding: [.left, .bottom])
            $0.height(Theme.titleButtonheight)
            
            $0.titleLabel?.textColor = .textDarkBlue
            $0.setTitle(title, for: .normal)
            $0.addTarget(for: .touchUpInside) { action() }
        }
    }
}

//MARK: - Templates
extension TitledTextField {
    static func createUserNameField(title: String) -> TitledTextField {
        return TitledTextField().then {
            $0.title = title
            $0.textField.returnKeyType = .next
            $0.textField.autocapitalizationType = .none
            $0.textField.autocorrectionType = .no
            $0.textField.spellCheckingType = .no
        }
    }
    
    static func createPasswordField(title: String) -> TitledTextField {
        return TitledTextField().then {
            $0.title = title
            $0.textField.autocapitalizationType = .none
            $0.textField.autocorrectionType = .no
            $0.textField.spellCheckingType = .no
            $0.textField.isSecureTextEntry = true
        }
    }
}

//MARK: - Theme
extension TitledTextField {
    enum Theme {
        // Fonts
        static let titleLabelFont: UIFont = .circular(style: .bold, size: 16)
        static let textFieldFont: UIFont = .circular(style: .book, size: 13)
        
        // Sizes
        static let mainheight: CGFloat = 60.0
        static let titleLabelHeight: CGFloat = 20.0
        static let textfieldHeight: CGFloat = 35.0
        static let titleButtonheight: CGFloat = 20.0
        static let shadowCornerRadius: CGFloat = 6.0
        static let borderWidth: CGFloat = 1.0
        
        // Offsets
        static let contentSideOffset: CGFloat = 2.0
        static let fieldTopOffset: CGFloat = 5.0
    }
}
