import UIKit

final class TransitionController: NSObject, UINavigationControllerDelegate {
    
    var interactionController: UIPercentDrivenInteractiveTransition?
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let item = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        toVC.navigationItem.backBarButtonItem = item
        
        switch operation {
        case .push:
            // Sample of usage different animation controllers
            //      if toVC is OfferDetailsVC {
            //        return OfferDetailsPresentationAC()
            //      } else {
            //        return NavigationPresentationAC()
            //      }
            return NavigationPresentationAC()
        case .pop:
            guard let nc = navigationController as? NavigationViewController else { return nil }
            if nc.isPopedToRoot {
                nc.isPopedToRoot = false
                return nil
            } else {
                return NavigationDismissionAC()
            }
        default: return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
      return interactionController
    }
}

//MARK: - Custom Dragging Implementation
extension UINavigationController {
    static private var coordinatorHelperKey = "UINavigationController.TransitionCoordinatorHelper"
    
    
    var transitionCoordinatorHelper: TransitionController? {
      return objc_getAssociatedObject(self, &UINavigationController.coordinatorHelperKey) as? TransitionController
    }
    
    func addCustomTransitioning() {
      
      var object = objc_getAssociatedObject(self, &UINavigationController.coordinatorHelperKey)
      
      guard object == nil else {
        return
      }
      
      object = TransitionController()
      let nonatomic = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
      objc_setAssociatedObject(self, &UINavigationController.coordinatorHelperKey, object, nonatomic)
      
      delegate = object as? TransitionController
      
      let popRecognizer = UIPanGestureRecognizer() { [weak self] recognizer in
        self?.handleRecognizer(recognizer: recognizer as! UIPanGestureRecognizer)
      }
      view.addGestureRecognizer(popRecognizer)
    }
    
    private func handleRecognizer(recognizer: UIPanGestureRecognizer) {
      guard let recognizerView = recognizer.view else {
        transitionCoordinatorHelper?.interactionController = nil
        return
      }
      
      let percent = recognizer.translation(in: recognizerView).x / recognizerView.bounds.size.width
      
      if recognizer.state == .began && percent >= 0 {
        transitionCoordinatorHelper?.interactionController = UIPercentDrivenInteractiveTransition()
        popViewController(animated: true)
      } else if recognizer.state == .changed, let interactionController = transitionCoordinatorHelper?.interactionController {
        interactionController.update(percent)
      } else if recognizer.state == .ended {
        if percent > 0.3 && recognizer.state != .cancelled {
          transitionCoordinatorHelper?.interactionController?.finish()
        } else {
          transitionCoordinatorHelper?.interactionController?.cancel()
        }
        transitionCoordinatorHelper?.interactionController = nil
      }
    }
}
