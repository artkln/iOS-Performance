//
//  SharesControl.swift
//  VK Client
//
//  Created by Артём Калинин on 25.03.2021.
//

import UIKit

@IBDesignable class SharesControl: UIControl {

    @IBInspectable var sharesCount: Int = 0 {
        didSet {
            updateLabelText()
        }
    }
    
    @IBInspectable var shareImage: UIImage? = nil {
        didSet {
            shareImageView.image = shareImage
        }
    }
    
    private var stackView: UIStackView!
    private var countLabel: UILabel!
    private var shareImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
        
        if sharesCount < 10 {
            stackView.frame.size.width = 42
        }
    }

    private func commonInit() {
        countLabel = UILabel()
        shareImageView = UIImageView()
        shareImageView.contentMode = .center
        countLabel.textAlignment = .center
        stackView = UIStackView(arrangedSubviews: [countLabel, shareImageView])
        
        addSubview(stackView)
        
        stackView.spacing = 0
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        updateSelectionState()
    }
    
    private func updateLabelText() {
        let additionalShares = isSelected ? 1 : 0
        let totalShares = sharesCount + additionalShares
        
        UIView.transition(with: countLabel,
                          duration: 0.20,
                          options: .transitionFlipFromTop,
                          animations: {
                self.countLabel.text = "\(totalShares)"
        })
    }
    
    private func updateSelectionState() {
        let color = isSelected ? tintColor : .black
        countLabel.textColor = color
        shareImageView.tintColor = color
        updateLabelText()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isSelected = !isSelected
        updateSelectionState()
        
        let startAnimation = CABasicAnimation(keyPath: "transform.scale")
        startAnimation.fromValue = 1
        startAnimation.toValue = 1.2
        startAnimation.duration = 0.10
        shareImageView.layer.add(startAnimation, forKey: nil)
        
        let endAnimation = CABasicAnimation(keyPath: "transform.scale")
        endAnimation.beginTime = CACurrentMediaTime() + 0.10
        endAnimation.fromValue = 1.2
        endAnimation.toValue = 1
        endAnimation.duration = 0.10
        shareImageView.layer.add(endAnimation, forKey: nil)
        
        sendActions(for: .valueChanged)
    }
}
