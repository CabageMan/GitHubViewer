import UIKit

final class NavigationPresentationAC: NSObject, UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return TimeInterval(UINavigationController.hideShowBarDuration)
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let duration = transitionDuration(using: transitionContext)
    
    guard let fromVC = transitionContext.viewController(forKey: .from),
      let toVC = transitionContext.viewController(forKey: .to)
      else {
        CustomTransitionAnimation.alphaPresent(using: transitionContext, duration: duration)
        return
    }
    
    let containerView = transitionContext.containerView
    
    
    
    // Configure transition subviews
    let toFrame = transitionContext.finalFrame(for: toVC)
    toVC.view.frame = toFrame.offsetBy(dx: toFrame.width, dy: 0)
    containerView.addSubview(toVC.view)
    
    // Animations
    let animations = {
      UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
        toVC.view.frame = toFrame
        fromVC.view.frame = fromVC.view.frame.offsetBy(dx: -fromVC.view.frame.width, dy: 0)
      }
    }
    
    UIView.animateKeyframes(withDuration: duration,
                            delay: 0,
                            options: .calculationModeCubic,
                            animations: animations,
                            completion: { _ in
                              transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })
  }
}
