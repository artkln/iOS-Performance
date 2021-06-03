//
//  ImageWithShadow.swift
//  VK Client
//
//  Created by Артём Калинин on 18.03.2021.
//

import UIKit

@IBDesignable class ImageWithShadow: UIView {

    @IBInspectable var shadowColor: UIColor = .black {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.5 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 8 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 0) {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }
    
    var image: UIImage? = nil {
        didSet {
            imageView.image = image
            setNeedsDisplay()
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            imageView.layer.masksToBounds = cornerRadius > 0
            imageView.layer.cornerRadius = cornerRadius
        }
    }
    
    
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        
        imageView.layer.cornerRadius = imageView.bounds.width / 2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchesBeganAnimation = CABasicAnimation(keyPath: "transform.scale")
        touchesBeganAnimation.fromValue = 1
        touchesBeganAnimation.toValue = 0.8
        touchesBeganAnimation.duration = 0.5
        touchesBeganAnimation.fillMode = .forwards
        touchesBeganAnimation.isRemovedOnCompletion = false
        imageView.layer.add(touchesBeganAnimation, forKey: nil)
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
        imageView.layer.add(touchesEndedAnimation, forKey: nil)
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
        imageView.layer.add(touchesCancelledAnimation, forKey: nil)
    }
}
