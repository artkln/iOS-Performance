//
//  PhotosCell.swift
//  VK Client
//
//  Created by Артём Калинин on 11.03.2021.
//

import UIKit

class PhotosCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImage: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImage.image = nil
    }
    
    func configure(photo: Photo) {
        
        self.photoImage.image = UIImage(data: photo.image as Data)
        
        self.alpha = 0
        self.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.25,
                       options: [],
                       animations: {
                        self.alpha = 1
                       },
                       completion: nil)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.25,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                        self.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
}
