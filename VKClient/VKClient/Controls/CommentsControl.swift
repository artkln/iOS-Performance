//
//  CommentsControl.swift
//  VK Client
//
//  Created by Артём Калинин on 25.03.2021.
//

import UIKit

@IBDesignable class CommentsControl: UIControl {
    
    @IBInspectable var commentsCount: Int = 0 {
        didSet {
            updateLabelText()
        }
    }
    
    @IBInspectable var commentImage: UIImage? = nil {
        didSet {
            commentImageView.image = commentImage
        }
    }
    
    private var stackView: UIStackView!
    private var countLabel: UILabel!
    private var commentImageView: UIImageView!
    
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
        
        if commentsCount < 10 {
            stackView.frame.size.width = 42
        }
    }

    private func commonInit() {
        countLabel = UILabel()
        commentImageView = UIImageView()
        commentImageView.contentMode = .center
        countLabel.textAlignment = .center
        stackView = UIStackView(arrangedSubviews: [countLabel, commentImageView])
        
        addSubview(stackView)
        
        stackView.spacing = 0
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
    }
 
    private func updateLabelText() {
        countLabel.text = "\(commentsCount)"
    }
}
