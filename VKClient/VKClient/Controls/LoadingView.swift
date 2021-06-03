//
//  LoadingView.swift
//  VK Client
//
//  Created by Артём Калинин on 01.04.2021.
//

import UIKit

@IBDesignable class LoadingView: UIView {
    
    let cloudLayer = CAShapeLayer()
    
    override func draw(_ rect: CGRect) {
        let cloudPath = UIBezierPath()
        cloudPath.lineCapStyle = .round
        
        cloudPath.move(to: CGPoint(x: rect.minX + 13.3, y: rect.height - 1.67))
        
        cloudPath.addCurve(to: CGPoint(x: rect.minX + 18.67, y: rect.height - 16.8),
                           controlPoint1: CGPoint(x: rect.minX + 3.6, y: rect.height - 3.33),
                           controlPoint2: CGPoint(x: rect.minX + 5.67, y: rect.height - 18.9))
        
        cloudPath.addCurve(to: CGPoint(x: rect.minX + 34.67, y: rect.height - 30.13),
                           controlPoint1: CGPoint(x: rect.minX + 14, y: rect.height - 25),
                           controlPoint2: CGPoint(x: rect.minX + 25, y: rect.height - 37))
        
        cloudPath.addCurve(to: CGPoint(x: rect.minX + 65.82, y: rect.height - 21.23),
                           controlPoint1: CGPoint(x: rect.minX + 38.67, y: rect.height - 50),
                           controlPoint2: CGPoint(x: rect.minX + 72.33, y: rect.height - 45.33))
        
        cloudPath.addCurve(to: CGPoint(x: rect.minX + 66.67, y: rect.height - 1.67),
                           controlPoint1: CGPoint(x: rect.minX + 78.47, y: rect.height - 22),
                           controlPoint2: CGPoint(x: rect.minX + 82.33, y: rect.height - 2.57))
        
        cloudPath.addLine(to: CGPoint(x: rect.minX + 13.3, y: rect.height - 1.67))
        
        cloudPath.close()
        
        cloudLayer.path = cloudPath.cgPath
        cloudLayer.fillColor = nil
        cloudLayer.strokeColor = UIColor.darkGray.cgColor
        cloudLayer.lineWidth = 5
        
        layer.addSublayer(cloudLayer)
    }
    
    override func layoutSubviews() {
        self.alpha = 0
    }
    
    func animate() {
        self.alpha = 1
        
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = 0
        strokeStartAnimation.toValue = 1

        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 2

        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 2
        animationGroup.fillMode = .backwards
        animationGroup.repeatCount = .infinity
        animationGroup.animations = [strokeStartAnimation, strokeEndAnimation]

        cloudLayer.add(animationGroup, forKey: nil)
    }
}
