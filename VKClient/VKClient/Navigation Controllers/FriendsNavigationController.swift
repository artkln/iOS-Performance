//
//  FriendsNavigationController.swift
//  VK Client
//
//  Created by Артём Калинин on 23.03.2021.
//

import UIKit

@IBDesignable class FriendsNavigationController: UINavigationController {

    private let navigationDelegate = SlideNavigationControllerDelegate()
    
    @IBInspectable var startColor: UIColor = .white
    @IBInspectable var endColor: UIColor = .white
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = navigationDelegate
        UIView.getGradient(on: friendsNavBar, with: [startColor, endColor], isVertical: false)
    }
    
    @IBOutlet weak var friendsNavBar: UINavigationBar!
    
}
