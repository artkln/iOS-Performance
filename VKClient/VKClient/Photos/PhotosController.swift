//
//  PhotosController.swift
//  VK Client
//
//  Created by Артём Калинин on 11.03.2021.
//

import UIKit
import RealmSwift

class PhotosController: UIViewController {

    let networkManager = NetworkManager.shared
    var selectedIndex: Int = 0
    var selectedPhotos: List<Photo>!
    var token: NotificationToken?
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let ownerId = FriendsController.selectedFriend?.id {
            pairTableAndRealm(id: ownerId)
            networkManager.getPhotos(id: ownerId)
        }
        
        collectionView.backgroundColor = UIColor(red: 0.83, green: 0.80, blue: 0.72, alpha: 1.00)
    }
    
    func pairTableAndRealm(id: Int) {
        guard let realm = try? Realm(), let owner = realm.object(ofType: User.self, forPrimaryKey: id) else { return }
        
        selectedPhotos = owner.photos
        
        token = selectedPhotos.observe { [weak self] (changes: RealmCollectionChange) in
            guard let collectionView = self?.collectionView else { return }
            switch changes {
            case .initial:
                collectionView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                collectionView.performBatchUpdates({
                    collectionView.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0) }))
                    collectionView.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0) }))
                    collectionView.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0) }))
                }, completion: nil)
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
}

extension PhotosController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedPhotos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCell", for: indexPath) as! PhotosCell
    
        cell.configure(photo: selectedPhotos[indexPath.item])
        
        return cell
    }
    
    private func willDisplayCellAnimation(cell: UICollectionViewCell) {
        UIView.animate(withDuration: 0.5,
                       delay: 0.25,
                       options: [],
                       animations: {
                        cell.alpha = 1
                       },
                       completion: nil)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.25,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                        cell.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    private func didEndDisplayingCellAnimation(cell: UICollectionViewCell) {
        UIView.animate(withDuration: 0.5,
                       delay: 0.25,
                       options: [],
                       animations: {
                        cell.alpha = 0
                       },
                       completion: nil)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.25,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                        cell.transform = CGAffineTransform(scaleX: 0, y: 0)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        willDisplayCellAnimation(cell: cell)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        didEndDisplayingCellAnimation(cell: cell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = collectionView.bounds.width
        let insets = collectionView.contentInset.left + collectionView.contentInset.right
        width -= insets
        width -= 8
        width /= 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        performSegue(withIdentifier: "toBrowse", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBrowse",
           let destination = segue.destination as? BrowsingPhotosViewController {
            destination.selectedIndex = selectedIndex
            destination.browsingPhotos = selectedPhotos.map { UIImage(data: $0.image as Data)! }
        }
    }
}
