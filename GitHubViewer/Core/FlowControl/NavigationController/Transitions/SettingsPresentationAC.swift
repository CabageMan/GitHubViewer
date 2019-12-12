import UIKit

final class SettingsPresentationAC: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(UINavigationController.hideShowBarDuration)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let duration = transitionDuration(using: transitionContext)
        
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
        else {
            CustomTransitionAnimation.alphaPresent(using: transitionContext, duration: duration)
            return
        }
        
        let containerView = transitionContext.containerView
        
        let toFrame = transitionContext.finalFrame(for: toVC)
        toVC.view.do {
            $0.frame = toFrame.offsetBy(dx: 0.0, dy: toFrame.height)
            $0.add(to: containerView)
        }
        
        let animations = {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.0) {
                toVC.view.frame = toFrame
            }
        }
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0.0,
            options: .calculationModeCubic,
            animations: animations,
            completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
}
