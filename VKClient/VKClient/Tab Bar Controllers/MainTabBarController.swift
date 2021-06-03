//
//  MainTabBarController.swift
//  VK Client
//
//  Created by Артём Калинин on 24.03.2021.
//

import UIKit

class MainTabBarController: UITabBarController {

    @IBInspectable var startColor: UIColor = .white
    @IBInspectable var endColor: UIColor = .white
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIView.getGradient(on: mainTabBar, with: [startColor, endColor], isVertical: false)
    }
    
    @IBOutlet weak var mainTabBar: UITabBar!
}
