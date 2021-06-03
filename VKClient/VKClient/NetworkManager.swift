//
//  NetworkManager.swift
//  VK Client
//
//  Created by Артём Калинин on 24.04.2021.
//

import Foundation
import Alamofire
import RealmSwift
import FirebaseFirestore

extension Session {
    static let custom: Session = {
        let configuration = URLSessionConfiguration.default
        
        let afSession = Session(configuration: configuration)
        return afSession
    }()
}

class UserSession {
    static let shared = UserSession()
    
    private init(){}
    
    var token: String = ""
    var userId: Int = 0
}

class NetworkManager {
 
    static let shared = NetworkManager()
    private init() { }
    
    private let baseUrl = "https://api.vk.com/method/"
    
    func saveFriendsData(friends: [User]) {
        do {
            let realm = try Realm()
            
            let oldFriends = realm.objects(User.self)
            let newFriends = friends.sorted(by: { $0.id < $1.id })
            
            print(realm.configuration.fileURL)
            if oldFriends.count != newFriends.count {
                try realm.write {
                    realm.delete(oldFriends)
                    realm.add(newFriends)
                }
            } else {
                for i in 0..<oldFriends.count {
                    if oldFriends[i].fullName != newFriends[i].fullName ||
                        oldFriends[i].avatar != newFriends[i].avatar ||
                        oldFriends[i].id != newFriends[i].id {
                        try realm.write {
                            realm.delete(oldFriends)
                            realm.add(newFriends)
                        }
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    
    func savePhotosData(ownerId: Int, photos: [Photo]) {
        do {
            let realm = try Realm()
            
            guard let owner = realm.object(ofType: User.self, forPrimaryKey: ownerId) else { return }
            
            let oldPhotos = owner.photos
            let newPhotos = photos.sorted(by: { $0.id < $1.id })
            
            if oldPhotos.count != newPhotos.count {
                try realm.write {
                    realm.delete(oldPhotos)
                    owner.photos.append(objectsIn: newPhotos)
                }
            } else {
                for i in 0..<oldPhotos.count {
                    if oldPhotos[i].id != newPhotos[i].id ||
                        oldPhotos[i].ownerId != newPhotos[i].ownerId ||
                        oldPhotos[i].image != newPhotos[i].image {
                        try realm.write {
                            realm.delete(oldPhotos)
                            owner.photos.append(objectsIn: newPhotos)
                        }
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    
    func saveGroupsData(groups: [Group]) {
        do {
            let realm = try Realm()
            
            let oldGroups = realm.objects(Group.self)
            let newGroups = groups.sorted(by: { $0.id < $1.id })
            
            if oldGroups.count != newGroups.count {
                try realm.write {
                    realm.delete(oldGroups)
                    realm.add(newGroups)
                }
            } else {
                for i in 0..<oldGroups.count {
                    if oldGroups[i].id != newGroups[i].id ||
                        oldGroups[i].name != newGroups[i].name ||
                        oldGroups[i].avatar != newGroups[i].avatar {
                        try realm.write {
                            realm.delete(oldGroups)
                            realm.add(newGroups)
                        }
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    
    func saveToFirestore(groups: [Group]) {
        // Setting up the Cloud Firestore
        // 1
        let database = Firestore.firestore()
        // 2
        let groupsToSend = groups
            .map { $0.toFirestore() }
            .reduce([:]) { $0.merging($1) { (current, _) in current } }
        // 3
        database.collection("users").document(String(describing: UserSession.shared.userId)).setData(groupsToSend, merge: true) { error in
        if let error = error {
            print(error.localizedDescription)
            } else { print("data saved")}
        }
    }
    
    func deleteFromFirestore(group: Group) {
        // Setting up the Cloud Firestore
        // 1
        let database = Firestore.firestore()
            
        database.collection("users").document(String(describing: UserSession.shared.userId)).updateData([
            String(describing: group.id) : FieldValue.delete()
        ])
            { error in
        if let error = error {
            print(error.localizedDescription)
            } else { print("data saved")}
        }
    }
    
    func getFriends() {
        let parameters = [
            "user_id": String(describing: UserSession.shared.userId),
            "order": "name",
            "fields": "photo_200_orig",
            "access_token" : UserSession.shared.token,
            "v" : "5.103"
        ]
        
        let path = "friends.get"
        let url = baseUrl + path
        
        Session.custom.request(url, method: .get, parameters: parameters).responseData { [weak self] response in
            
            guard let data = response.value else { return }
            let friends = try! JSONDecoder().decode(UserResponse.self, from: data).response
    
            self?.saveFriendsData(friends: friends.items)
        }
    }
    
    func getPhotos(id: Int) {
        let parameters = [
            "owner_id": String(describing: id),
            "skip_hidden": "true",
            "access_token" : UserSession.shared.token,
            "v" : "5.103"
        ]
        
        let path = "photos.getAll"
        let url = baseUrl + path
        
        Session.custom.request(url, method: .get, parameters: parameters).responseData { [weak self] response in
            
            guard let data = response.value else { return }
            let photos = try! JSONDecoder().decode(PhotoResponse.self, from: data).response
            
            self?.savePhotosData(ownerId: id, photos: photos.items)
        }
    }
    
    func getGroups() {
        let parameters = [
            "user_id": String(describing: UserSession.shared.userId),
            "extended": "true",
            "access_token" : UserSession.shared.token,
            "v" : "5.103"
        ]
        
        let path = "groups.get"
        let url = baseUrl + path
        
        Session.custom.request(url, method: .get, parameters: parameters).responseData { [weak self] response in
            
            guard let data = response.value else { return }
            let groups = try! JSONDecoder().decode(GroupResponse.self, from: data).response
            
            self?.saveGroupsData(groups: groups.items)
            self?.saveToFirestore(groups: groups.items)
        }
    }
    
    func searchGroups(searchText text: String, completion: @escaping ([Group]) -> Void) {
        let parameters = [
            "q": text,
            "access_token" : UserSession.shared.token,
            "v" : "5.103"
        ]
        
        let path = "groups.search"
        let url = baseUrl + path
        
        Session.custom.request(url, method: .get, parameters: parameters).responseData { response in
            
            guard let data = response.value else { return }
            let searchResults = try! JSONDecoder().decode(GroupResponse.self, from: data).response
            
            completion(searchResults.items)
        }
    }
    
    func addGroup(group: Group) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(group)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func saveNewGroup(searchId: Int) {
        let parameters = [
            "group_id": String(describing: searchId),
            "access_token" : UserSession.shared.token,
            "v" : "5.103"
        ]
        
        let path = "groups.getById"
        let url = baseUrl + path
        
        Session.custom.request(url, method: .get, parameters: parameters).responseData { [weak self] response in
            
            guard let data = response.value else { return }
            let searchResults = try! JSONDecoder().decode(SearchByIdResponse.self, from: data).response
            
            if let groupToAdd = searchResults.first {
                self?.addGroup(group: groupToAdd)
                self?.saveToFirestore(groups: [groupToAdd])
            }
        }
    }
    
    func deleteGroupFromFirestore(searchId: Int) {
        let parameters = [
            "group_id": String(describing: searchId),
            "access_token" : UserSession.shared.token,
            "v" : "5.103"
        ]
        
        let path = "groups.getById"
        let url = baseUrl + path
        
        Session.custom.request(url, method: .get, parameters: parameters).responseData { [weak self] response in
            
            guard let data = response.value else { return }
            let searchResults = try! JSONDecoder().decode(SearchByIdResponse.self, from: data).response
            
            if let groupToDel = searchResults.first {
                self?.deleteFromFirestore(group: groupToDel)
            }
        }
    }
    
    func joinGroup(id: Int) {
        let parameters = [
            "group_id": String(describing: id),
            "access_token" : UserSession.shared.token,
            "v" : "5.103"
        ]
        
        let path = "groups.join"
        let url = baseUrl + path
        
        Session.custom.request(url, method: .get, parameters: parameters).response { _ in }
    }
    
    func leaveGroup(id: Int) {
        let parameters = [
            "group_id": String(describing: id),
            "access_token" : UserSession.shared.token,
            "v" : "5.103"
        ]
        
        let path = "groups.leave"
        let url = baseUrl + path
        
        Session.custom.request(url, method: .get, parameters: parameters).responseJSON { _ in }
    }
}
