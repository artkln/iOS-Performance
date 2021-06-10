//
//  ImageNewsCell.swift
//  VKClient
//
//  Created by Артём Калинин on 10.06.2021.
//

import UIKit

class ImageNewsCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var wallImages: UICollectionView! {
        didSet {
            self.wallImages.register(UINib(nibName: "WallImagesCell", bundle: nil), forCellWithReuseIdentifier: "WallImagesCell")
        }
    }
    
    var cellImages = [UIImage]()
    
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
        cellImages = []
    }
    
    func configure(images: [UIImage]) {
        self.cellImages = images
        self.wallImages.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return cellImages.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WallImagesCell", for: indexPath) as! WallImagesCell
        
        cell.configure(image: cellImages[indexPath.item])
        
        return cell
    }
}
