//
//  SlideNavigationControllerDelegate.swift
//  VK Client
//
//  Created by Артём Калинин on 14.04.2021.
//

import UIKit

class SlideNavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    
    let interactiveTransition = SlideInteractiveTransition()

    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning)
    -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.hasStarted ? interactiveTransition : nil
    }
    
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            self.interactiveTransition.viewController = toVC
            return SlidePresentAnimator()
        } else if operation == .pop {
            if navigationController.viewControllers.first != toVC {
                self.interactiveTransition.viewController = toVC
            }
            return SlideDismissAnimator()
        }
        return nil
    }
}
