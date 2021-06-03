//
//  AllGroupsCell.swift
//  VK Client
//
//  Created by Артём Калинин on 09.03.2021.
//

import UIKit

class AllGroupsCell: UITableViewCell {

    @IBInspectable var startColor: UIColor = .white
    @IBInspectable var endColor: UIColor = .white
    
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupAvatar: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        groupName.text = ""
        groupAvatar.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.getGradient(on: self, with: [startColor, endColor], isVertical: true)
    }
    
    func configure(name: String, avatar: NSData) {
        self.groupName.text = name
        self.groupAvatar.image = UIImage(data: avatar as Data)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
