//
//  NewsCell.swift
//  VK Client
//
//  Created by Артём Калинин on 24.03.2021.
//

import UIKit

class NewsCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profileImage: RoundedImage!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var wallText: UILabel!
    
    @IBOutlet private weak var wallImages: UICollectionView! {
        didSet {
            self.wallImages.register(UINib.init(nibName: "WallImagesCell", bundle: nil), forCellWithReuseIdentifier: "WallImagesCell")
        }
    }
    
    var cellImages = [UIImage]()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        name.text = ""
        date.text = ""
        wallText.text = ""
        cellImages = []
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(name: String, profileImage: UIImage, date: String, wallText: String, images: [UIImage]) {
        self.name.text = name
        self.profileImage.image = profileImage
        self.date.text = date
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


