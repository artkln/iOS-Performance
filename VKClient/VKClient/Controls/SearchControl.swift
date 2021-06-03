//
//  SearchControl.swift
//  VK Client
//
//  Created by Артём Калинин on 06.04.2021.
//

import UIKit

class SearchControl: UIControl, UITextFieldDelegate {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var searchText: String = "" {
        didSet {
            self.sendActions(for: .valueChanged)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("SearchControl", owner: self, options: nil)
        contentView.fixInView(self)
    }
    
    override func layoutSubviews() {
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.tintColor = .black
        cancelButton.transform = CGAffineTransform(translationX: 80, y: 0)
    }
    
    func hideKeyboard() {
        contentView.endEditing(true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        textField.text = ""
        searchText = ""
        contentView.endEditing(true)
    }
    
//    MARK: - Text field delegate
    
    private func beginEditingAnimation() {
        textField.constraintWithIdentifier("widthConstraint")?.constant = self.textField.bounds.size.width - 51
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       animations: { () -> Void in
                        self.layoutIfNeeded()
                       },
                       completion: nil);
        
        UIView.animate(withDuration: 1,
                           delay: 0,
                           options: .curveEaseOut,
                           animations: {
                               self.cancelButton.transform = .identity
                           },
                           completion: nil)
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                        self.imageView.center = CGPoint(x: self.frame.origin.x + 17.5, y: self.center.y)
        })
    }
    
    private func endEditingAnimation() {
        textField.constraintWithIdentifier("widthConstraint")?.constant = self.textField.bounds.size.width + 51

        UIView.animate(withDuration: 1,
                       delay: 0,
                       animations: { () -> Void in
                        self.layoutIfNeeded()
                       },
                       completion: nil);

        UIView.animate(withDuration: 1,
                           delay: 0,
                           options: .curveEaseOut,
                           animations: {
                               self.cancelButton.transform = CGAffineTransform(translationX: 80, y: 0)
                           },
                           completion: nil)

        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                        self.imageView.center = CGPoint(x: self.center.x, y: self.center.y)
        })
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        beginEditingAnimation()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        endEditingAnimation()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        contentView.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
        
        self.searchText = newString
        
        return true
    }
}

extension UIView
{
    func fixInView(_ container: UIView!) -> Void {
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
    
    func constraintWithIdentifier(_ identifier: String) -> NSLayoutConstraint? {
            return self.constraints.first { $0.identifier == identifier }
    }
}
