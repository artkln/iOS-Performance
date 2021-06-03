//
//  FriendsCell.swift
//  VK Client
//
//  Created by Артём Калинин on 11.03.2021.
//

import UIKit

class FriendsCell: UITableViewCell {

    @IBOutlet weak var friendAvatar: ImageWithShadow!
    @IBOutlet weak var friendName: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        friendName.text = ""
        friendAvatar.image = nil
    }
    
    private func cellAnimation() {
        self.alpha = 0
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [],
                       animations: {
                        self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                       },
                       completion: nil)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.5,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                        self.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
        
        UIView.animate(withDuration: 0.33,
                       delay: 0,
                       options: [],
                       animations: {
                        self.frame.origin.x += 25
                       })
        
        UIView.animate(withDuration: 0.33,
                       delay: 0.33,
                       options: [],
                       animations: {
                        self.frame.origin.x -= 50})
        
        UIView.animate(withDuration: 0.33,
                       delay: 0.66,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                        self.frame.origin.x += 25})
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: [],
                       animations: {
                        self.alpha = 1
                       },
                       completion: nil)
    }
    
    func configure(name: String, avatar: NSData) {
        self.friendName.text = name
        self.friendAvatar.image = UIImage(data: avatar as Data)
        
        cellAnimation()
    }
    
    @IBInspectable var startColor: UIColor = .white
    @IBInspectable var endColor: UIColor = .white
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.getGradient(on: self, with: [startColor, endColor], isVertical: false)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension UIView {
    static func getGradient(on view: UIView, with colors: [UIColor], isVertical: Bool) {
        
        let gradient = CAGradientLayer()
        var bounds = view.bounds
        
        if view is UINavigationBar {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            bounds.size.height += (window?.windowScene?.statusBarManager?.statusBarFrame.height)!
        }
        
        gradient.frame = bounds
        gradient.colors = colors.map { $0.cgColor }
        
        if isVertical {
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 0, y: 1)
            gradient.locations = [0 as NSNumber, 0.5 as NSNumber]
        } else {
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 1, y: 0)
        }
        
        if let image = getImageFrom(gradientLayer: gradient) {
            
            switch view {
            case let navBar as UINavigationBar:
                navBar.setBackgroundImage(image, for: UIBarMetrics.default)
            case let cell as UITableViewCell:
                cell.backgroundView = UIImageView(image: image)
            case let tabBar as UITabBar:
                tabBar.backgroundImage = image
            case let searchBar as UISearchBar:
                searchBar.backgroundImage = image
            default:
                view.backgroundColor = UIColor(patternImage: image)
            }
        }
    }
    
    static func getImageFrom(gradientLayer: CAGradientLayer) -> UIImage? {
        var gradientImage: UIImage?
        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
}
