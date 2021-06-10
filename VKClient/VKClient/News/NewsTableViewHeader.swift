//
//  NewsTableViewHeader.swift
//  VKClient
//
//  Created by Артём Калинин on 08.06.2021.
//

import UIKit

class NewsTableViewHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profileImage: RoundedImage!
    @IBOutlet weak var date: UILabel!
  
    override func prepareForReuse() {
        super.prepareForReuse()
        name.text = ""
        date.text = ""
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.84, green: 0.81, blue: 0.75, alpha: 1.00)
        backgroundView = view
    }
    
    func configure(name: String, profileImage: UIImage, date: String) {
        self.name.text = name
        self.profileImage.image = profileImage
        self.date.text = date
    }
}
