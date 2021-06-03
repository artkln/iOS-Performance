//
//  ViewsControl.swift
//  VK Client
//
//  Created by Артём Калинин on 25.03.2021.
//

import UIKit

class ViewsControl: UIControl {

    @IBInspectable var viewsCount: Int = 0 {
        didSet {
            updateLabelText()
        }
    }
    
    @IBInspectable var viewImage: UIImage? = nil {
        didSet {
            viewImageView.image = viewImage
        }
    }
    
    private var stackView: UIStackView!
    private var countLabel: UILabel!
    private var viewImageView: UIImageView!
    
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
    }

    private func commonInit() {
        countLabel = UILabel()
        viewImageView = UIImageView()
        viewImageView.contentMode = .center
        countLabel.textAlignment = .center
        stackView = UIStackView(arrangedSubviews: [countLabel, viewImageView])
        
        addSubview(stackView)
        
        stackView.spacing = 0
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        updateLabelText()
    }
    
    private func updateLabelText() {
        countLabel.text = "\(viewsCount)"
    }
}
