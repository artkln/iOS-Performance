//
//  NewsNavigationController.swift
//  VK Client
//
//  Created by Артём Калинин on 24.03.2021.
//

import UIKit

class NewsNavigationController: UINavigationController {

    @IBInspectable var startColor: UIColor = .white
    @IBInspectable var endColor: UIColor = .white
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIView.getGradient(on: newsNavBar, with: [startColor, endColor], isVertical: false)
    }

    @IBOutlet weak var newsNavBar: UINavigationBar!
}
