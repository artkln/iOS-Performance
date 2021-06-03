//
//  SlideDismissAnimator.swift
//  VK Client
//
//  Created by Артём Калинин on 14.04.2021.
//

import UIKit

class SlideDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from)
        else { return }
        guard let destination = transitionContext.viewController(forKey: .to)
        else { return }
        
        let containerViewFrame = transitionContext.containerView.frame
        
        let sourceViewTargetFrame = CGRect(x: containerViewFrame.width / 2, y: -containerViewFrame.height / 2, width: containerViewFrame.width, height: containerViewFrame.height)
        
        let destinationViewTargetFrame = containerViewFrame
        
        transitionContext.containerView.addSubview(destination.view)
        transitionContext.containerView.sendSubviewToBack(destination.view)
        
        destination.view.frame = CGRect(x: -containerViewFrame.width,
                                        y: 0,
                                        width: source.view.frame.width,
                                        height: source.view.frame.height)
        
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0, animations: {
                destination.view.frame = destinationViewTargetFrame
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: self.transitionDuration(using: transitionContext), animations: {
                source.view.frame = sourceViewTargetFrame
                source.view.layer.anchorPoint = CGPoint(x: 1, y: 0)
                source.view.transform = CGAffineTransform(rotationAngle: -(.pi / 2))
            })
            
        }, completion: { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.removeFromParent()
            } else if transitionContext.transitionWasCancelled {
                source.view.frame = containerViewFrame
                source.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        })
    }
}
