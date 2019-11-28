import UIKit

protocol ModalAlertViewCompatibility {
    var closeAction: () -> Void {get set}
    func presentAlert()
}

extension ModalAlertViewCompatibility where Self: UIView {
    func presentAlert() {
        var alertView = self
        let vc = UIViewController().then {
            $0.modalPresentationStyle = .overFullScreen
            $0.modalTransitionStyle = .crossDissolve
            $0.view.backgroundColor = .modalAlert
            $0.view.addGesture(type: .tap) { [weak self] _ in self?.closeAction() }
        }
        alertView.add(to: vc.view).do {
            $0.centerInSuperview()
            $0.width(.modalAlertWidth)
            $0.height(.modalAlertHeight)
            
            $0.backgroundColor = .mainBackground
            $0.layer.cornerRadius = .modalAlertCornerRadius
        }
        if let topVC = UIViewController.current {
            alertView.closeAction = { [weak vc] in vc?.dismiss(animated: true) }
            topVC.present(vc, animated: true)
        }
    }
}
