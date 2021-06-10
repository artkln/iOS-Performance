//
//  FullNewsCell.swift
//  VKClient
//
//  Created by Артём Калинин on 09.06.2021.
//

import UIKit

class FullNewsCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var wallText: UILabel!
    
    @IBOutlet weak var wallImages: UICollectionView! {
        didSet {
            self.wallImages.register(UINib(nibName: "WallImagesCell", bundle: nil), forCellWithReuseIdentifier: "WallImagesCell")
        }
    }
    
    var cellImages = [UIImage]()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        wallText.text = ""
        cellImages = []
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(wallText: String, images: [UIImage]) {
        self.wallText.text = wallText
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
