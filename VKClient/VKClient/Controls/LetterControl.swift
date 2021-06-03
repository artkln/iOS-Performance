//
//  LetterControl.swift
//  VK Client
//
//  Created by Артём Калинин on 02.04.2021.
//

import UIKit

@IBDesignable class LetterControl: UIControl {

    var selectedIndex: Int? = nil {
        didSet {
            self.sendActions(for: .valueChanged)
        }
    }
    
    private var buttons: [UIButton] = []
    private var stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupView() {
        stackView.removeFromSuperview()
        self.buttons = []
        
        if (FriendsController.firstLetters.count > 0) {
            
            for letter in FriendsController.firstLetters {
                let button = UIButton(type: .system)
                button.setTitle(letter, for: .normal)
                button.setTitleColor(.systemBlue, for: .normal)
                button.setTitleColor(.systemBlue, for: .selected)
                button.addTarget(self, action: #selector(selectLetter(_:)), for: .touchUpInside)
                self.buttons.append(button)
            }
            
            stackView = UIStackView(arrangedSubviews: self.buttons)
            self.addSubview(stackView)
            
            stackView.spacing = 4
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.distribution = .fillEqually
        }
    }
    
    @objc private func selectLetter(_ sender: UIButton) {
        guard let index = self.buttons.firstIndex(of: sender) else { return }
        self.selectedIndex = index
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
}
