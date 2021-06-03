//
//  RoundedImage.swift
//  VK Client
//
//  Created by Артём Калинин on 24.03.2021.
//

import UIKit

class RoundedImage: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.masksToBounds = cornerRadius > 0
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor = .white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = bounds.width / 2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchesBeganAnimation = CABasicAnimation(keyPath: "transform.scale")
        touchesBeganAnimation.fromValue = 1
        touchesBeganAnimation.toValue = 0.8
        touchesBeganAnimation.duration = 0.5
        touchesBeganAnimation.fillMode = .forwards
        touchesBeganAnimation.isRemovedOnCompletion = false
        layer.add(touchesBeganAnimation, forKey: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchesEndedAnimation = CASpringAnimation(keyPath: "transform.scale")
        touchesEndedAnimation.fromValue = 0.8
        touchesEndedAnimation.toValue = 1
        touchesEndedAnimation.stiffness = 200
        touchesEndedAnimation.mass = 0.5
        touchesEndedAnimation.duration = 0.5
        touchesEndedAnimation.fillMode = .forwards
        touchesEndedAnimation.isRemovedOnCompletion = false
        layer.add(touchesEndedAnimation, forKey: nil)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchesCancelledAnimation = CASpringAnimation(keyPath: "transform.scale")
        touchesCancelledAnimation.fromValue = 0.8
        touchesCancelledAnimation.toValue = 1
        touchesCancelledAnimation.stiffness = 200
        touchesCancelledAnimation.mass = 0.5
        touchesCancelledAnimation.duration = 0.5
        touchesCancelledAnimation.fillMode = .forwards
        touchesCancelledAnimation.isRemovedOnCompletion = false
        layer.add(touchesCancelledAnimation, forKey: nil)
    }
} 
