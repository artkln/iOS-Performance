//
//  MyGroupsController.swift
//  VK Client
//
//  Created by Артём Калинин on 10.03.2021.
//

import UIKit
import RealmSwift

class MyGroupsController: UITableViewController, UISearchBarDelegate {

    let networkManager = NetworkManager.shared
    var groupsData: Results<Group>!
    var filteredData: Results<Group>!
    
    @IBInspectable var startColor: UIColor = .white
    @IBInspectable var endColor: UIColor = .white
    
    @IBOutlet weak var searchControl: SearchControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pairTableAndRealm()
        networkManager.getGroups()
        
        self.tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(red: 0.83, green: 0.80, blue: 0.72, alpha: 1.00)
    }
    
    var token: NotificationToken?
    
    func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        filteredData = realm.objects(Group.self).sorted(byKeyPath: "id")
        groupsData = filteredData
        token = filteredData.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case let .update(_, deletions, insertions, modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupsCell", for: indexPath) as! MyGroupsCell
        
        let groupName = filteredData[indexPath.row].name
        let groupAvatar = filteredData[indexPath.row].avatar
        
        cell.configure(name: groupName, avatar: groupAvatar)
        
        return cell
    }
    
    @IBAction func addGroup(unwindSegue: UIStoryboardSegue) {
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        searchControl.hideKeyboard()
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let groupToDelete = filteredData[indexPath.row]
            
            networkManager.deleteGroupFromFirestore(searchId: groupToDelete.id)
            
            networkManager.leaveGroup(id: groupToDelete.id)
            
            do {
                let realm = try Realm()
                realm.beginWrite()
                realm.delete(groupToDelete)
                try realm.commitWrite()
            } catch {
                print(error)
            }
        } 
    }
    
    @IBAction func textFieldDidChange(_ sender: Any) {
        
        guard let realm = try? Realm() else { return }
        
        filteredData = searchControl.searchText.isEmpty ? groupsData :
            realm.objects(Group.self).filter("name CONTAINS[c] %@", searchControl.searchText)
        
        tableView.reloadData()
    }
}
