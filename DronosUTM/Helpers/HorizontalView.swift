import UIKit

class HorizontalPresentation: NSObject, UIViewControllerAnimatedTransitioning {

    let isPresenting: Bool

    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        if isPresenting {
            guard let toView = transitionContext.view(forKey: .to) else { return }
            containerView.addSubview(toView)
            toView.transform = CGAffineTransform(translationX: containerView.bounds.width, y: 0)

            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                toView.transform = .identity
            }, completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        } else {
            guard let fromView = transitionContext.view(forKey: .from) else { return }

            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromView.transform = CGAffineTransform(translationX: containerView.bounds.width, y: 0)
            }, completion: { finished in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
}
