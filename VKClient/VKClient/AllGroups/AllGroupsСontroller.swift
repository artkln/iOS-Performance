//
//  AllGroupsСontroller.swift
//  VK Client
//
//  Created by Артём Калинин on 09.03.2021.
//

import UIKit

class AllGroupsController: UITableViewController, UISearchBarDelegate {

    let networkManager = NetworkManager.shared
    var groupsData = [Group]()
    var filteredData = [Group]()
    var selectedGroupId: Int!
    
    @IBInspectable var startColor: UIColor = .white
    @IBInspectable var endColor: UIColor = .white
    
    @IBOutlet weak var searchControl: SearchControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(red: 0.83, green: 0.80, blue: 0.72, alpha: 1.00)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllGroupsCell", for: indexPath) as! AllGroupsCell
        
        let groupName = filteredData[indexPath.row].name
        let groupAvatar = filteredData[indexPath.row].avatar
        
        cell.configure(name: groupName, avatar: groupAvatar)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedGroupId = filteredData[indexPath.row].id
        tableView.deselectRow(at: indexPath, animated: true)
        searchControl.hideKeyboard()
        performSegue(withIdentifier: "addGroup", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addGroup" {
            networkManager.joinGroup(id: selectedGroupId)
            networkManager.saveNewGroup(searchId: selectedGroupId)
        }
    }
    
    @IBAction func textFieldDidChange(_ sender: Any) {
        if searchControl.searchText.isEmpty {
            filteredData = groupsData
            tableView.reloadData()
        } else {
            networkManager.searchGroups(searchText: searchControl.searchText) { [weak self] searchResults in
                self?.filteredData = searchResults
                self?.tableView.reloadData()
            }
        }
    }
}
