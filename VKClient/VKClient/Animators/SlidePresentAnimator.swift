//
//  SlidePresentAnimator.swift
//  VK Client
//
//  Created by Артём Калинин on 13.04.2021.
//

import UIKit

class SlidePresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from)
        else { return }
        guard let destination = transitionContext.viewController(forKey: .to)
        else { return }
        
        let containerViewFrame = transitionContext.containerView.frame
        
        transitionContext.containerView.addSubview(destination.view)
        
        destination.view.frame = CGRect(x: containerViewFrame.width / 2, y: -containerViewFrame.height / 2, width: containerViewFrame.width, height: containerViewFrame.height)
        destination.view.layer.anchorPoint = CGPoint(x: 1, y: 0)
        destination.view.transform = CGAffineTransform(rotationAngle: -(.pi / 2))
        
        UIView.animate(
            withDuration: self.transitionDuration(using: transitionContext),
            animations: {
                destination.view.transform = .identity
            }
        ) { finished in
            source.view.removeFromSuperview()
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
}
