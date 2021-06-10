//
//  TextNewsCell.swift
//  VKClient
//
//  Created by Артём Калинин on 10.06.2021.
//

import UIKit

class TextNewsCell: UITableViewCell {

    @IBOutlet weak var wallText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        wallText.text = ""
    }
    
    func configure(wallText: String) {
        self.wallText.text = wallText
    }
}
