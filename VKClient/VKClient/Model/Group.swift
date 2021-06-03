//
//  Group.swift
//  VK Client
//
//  Created by Артём Калинин on 12.03.2021.
//

import UIKit
import RealmSwift

class GroupResponse: Decodable {
    let response: GroupItems
}

class GroupItems: Decodable {
    let items: [Group]
}

class SearchByIdResponse: Decodable {
    let response: [Group]
}

class Group: Object, Decodable {
    
    @objc dynamic var name = ""
    @objc dynamic var id = 0
    @objc dynamic var avatar = NSData()
    
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case avatar = "photo_200"
    }
    
    override static func primaryKey() -> String? {
           return "id"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try values.decode(String.self, forKey: .name)
        self.id = try values.decode(Int.self, forKey: .id)
        
        let stringUrl = try values.decode(String.self, forKey: .avatar)
        let avatarUrl = NSURL(string: stringUrl)! as URL
        self.avatar = try NSData(contentsOf: avatarUrl)
    }
    
    func toFirestore() -> [String: Any] {
        return [
            String(describing: id) : name
        ]
    }
}
