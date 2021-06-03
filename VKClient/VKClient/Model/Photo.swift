//
//  Photo.swift
//  VK Client
//
//  Created by Артём Калинин on 24.04.2021.
//

import UIKit
import RealmSwift

class PhotoResponse: Decodable {
    let response: PhotoItems
}

class PhotoItems: Decodable {
    let items: [Photo]
}

class Photo: Object, Decodable {
    @objc dynamic var id = 0
    @objc dynamic var ownerId = 0
    @objc dynamic var image = NSData()
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerId = "owner_id"
        case sizes
    }
    
    enum SizesKeys: String, CodingKey {
        case image = "url"
    }
    
    override static func primaryKey() -> String? {
           return "id"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .id)
        self.ownerId = try values.decode(Int.self, forKey: .ownerId)
        
        var sizesValues = try values.nestedUnkeyedContainer(forKey: .sizes)
        
        var sizeValue: KeyedDecodingContainer<Photo.SizesKeys>!
        for _ in 0..<sizesValues.count! {
            sizeValue = try sizesValues.nestedContainer(keyedBy: SizesKeys.self)
        }
        
        let stringUrl = try sizeValue.decode(String.self, forKey: .image)

        let imageUrl = NSURL(string: stringUrl)! as URL
        self.image = try NSData(contentsOf: imageUrl)
    }
}
