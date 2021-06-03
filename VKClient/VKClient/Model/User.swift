//
//  User.swift
//  VK Client
//
//  Created by Артём Калинин on 12.03.2021.
//

import UIKit
import RealmSwift

class UserResponse: Decodable {
    let response: UserItems
}

class UserItems: Decodable {
    let items: [User]
}

class User: Object, Decodable {
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var fullName = ""
    @objc dynamic var id = 0
    @objc dynamic var avatar = NSData()
    
    let photos = List<Photo>()
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case id
        case avatar = "photo_200_orig"
    }
    
    override static func primaryKey() -> String? {
           return "id"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.firstName = try values.decode(String.self, forKey: .firstName)
        self.lastName = try values.decode(String.self, forKey: .lastName)
        self.fullName = firstName + " " + lastName
        
        self.id = try values.decode(Int.self, forKey: .id)
        
        let stringUrl = try values.decode(String.self, forKey: .avatar)
        let avatarUrl = NSURL(string: stringUrl)! as URL
        self.avatar = try NSData(contentsOf: avatarUrl)
    }
}
