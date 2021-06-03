//
//  WallImagesCell.swift
//  VK Client
//
//  Created by Артём Калинин on 24.03.2021.
//

import UIKit

class WallImagesCell: UICollectionViewCell {
    
    @IBOutlet weak var wallImage: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        wallImage.image = nil
    }
    
    func configure(image: UIImage) {
        self.wallImage.image = image
    }
}
