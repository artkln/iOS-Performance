//
//  FriendsTableViewHeader.swift
//  VK Client
//
//  Created by Артём Калинин on 24.03.2021.
//

import UIKit

class FriendsTableViewHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(text: String) {
        titleLabel.text = text
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.66, green: 0.63, blue: 0.51, alpha: 1.00)
        backgroundView = view
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = nil
    }
}
