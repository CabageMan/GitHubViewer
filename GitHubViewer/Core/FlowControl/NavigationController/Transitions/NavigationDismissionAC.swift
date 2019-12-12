import UIKit

final class NavigationDismissionAC: NSObject, UIViewControllerAnimatedTransitioning {
    
  
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(UINavigationController.hideShowBarDuration)
    }
  
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let duration = transitionDuration(using: transitionContext)
        
        guard let fromVC = transitionContext.viewController(forKey: .from),
          let toVC = transitionContext.viewController(forKey: .to),
          let navigationBar = fromVC.navigationController?.navigationBar,
          let snapshot = navigationBar.snapshotView(afterScreenUpdates: false)
          else {
            CustomTransitionAnimation.alphaDismiss(using: transitionContext, duration: duration)
            return
        }
        
        let containerView = transitionContext.containerView
        
        // Configure transition subviews
        let fromVCTitle = fromVC.title
        let fromVcRightItems = fromVC.navigationItem.rightBarButtonItems
        let toFrame = transitionContext.finalFrame(for: toVC)
        
        toVC.view.frame = toFrame.offsetBy(dx: -0.3 * toFrame.width, dy: 0)
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        let snapshotFrame = navigationBar.convert(navigationBar.frame, to: containerView)
        snapshot.frame = CGRect(x: snapshotFrame.width,
                                y: 0,
                                width: snapshotFrame.width,
                                height: snapshotFrame.height)
        navigationBar.addSubview(snapshot)
        snapshot.alpha = 1
        
        navigationBar.transform = CGAffineTransform(translationX: -navigationBar.frame.width, y: 0)
        
        // Animations
        let animations = {
          UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
            toVC.view.frame = toFrame
            fromVC.view.frame = fromVC.view.frame.offsetBy(dx: fromVC.view.frame.width, dy: 0)
            fromVC.title = ""
            fromVC.navigationItem.rightBarButtonItems = nil
            navigationBar.transform = CGAffineTransform(translationX: 0, y: 0)
            snapshot.alpha = 0
          }
        }
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: animations,
            completion: { _ in
                navigationBar.transform = CGAffineTransform(translationX: 0, y: 0)
                fromVC.title = fromVCTitle
                fromVC.navigationItem.rightBarButtonItems = fromVcRightItems
                snapshot.alpha = 0
                snapshot.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
}
