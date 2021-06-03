//
//  FriendsController.swift
//  VK Client
//
//  Created by Артём Калинин on 11.03.2021.
//

import UIKit
import RealmSwift

class FriendsController: UITableViewController, UISearchBarDelegate {
    
    let networkManager = NetworkManager.shared
    static var selectedFriend: User?
    var friendsData: Results<User>!
    var filteredData: Results<User>!
    
    static var firstLetters: [String] = [] {
        didSet {
            FriendsController.letterControl.setupView()
            FriendsController.letterControl.frame = CGRect(
            x: UIScreen.main.bounds.size.width - 20,
            y: UIScreen.main.bounds.size.height / 2 - (CGFloat(FriendsController.firstLetters.count) * 18) / 2,
            width: 20,
            height: CGFloat(FriendsController.firstLetters.count * 18))
        }
    }
    
    var token: NotificationToken?
    
    private let headerReuseIdentifier = "FriendsHeader"
    
    @IBInspectable var startColor: UIColor = .white
    @IBInspectable var endColor: UIColor = .white
    
    static var letterControl = LetterControl(frame: CGRect(
            x: UIScreen.main.bounds.size.width - 20,
            y: UIScreen.main.bounds.size.height / 2 - (CGFloat(FriendsController.firstLetters.count) * 18) / 2,
            width: 20,
            height: CGFloat(FriendsController.firstLetters.count * 18)))
    
    @IBOutlet weak var searchControl: SearchControl!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let _ = filteredData {
            updateFirstLetters()
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(red: 0.83, green: 0.80, blue: 0.72, alpha: 1.00)
        tableView.register(UINib(nibName: "FriendsTableViewHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: headerReuseIdentifier)
        
        pairTableAndRealm()
        networkManager.getFriends()
        
        self.navigationController?.view.addSubview(FriendsController.letterControl)
        FriendsController.letterControl.addTarget(self, action: #selector(indexDidChange), for: .valueChanged)
    }
    
    func updateFirstLetters() {
        var tempFirstLetters: [String] = []
        for friend in filteredData! {
            if !tempFirstLetters.contains(String(friend.fullName.first!)) {
                tempFirstLetters.append(String(friend.fullName.first!))
            }
        }
        FriendsController.firstLetters = tempFirstLetters
    }
    
    func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        filteredData = realm.objects(User.self).sorted(byKeyPath: "fullName")
        friendsData = filteredData
        token = filteredData.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                self?.updateFirstLetters()
                tableView.reloadData()
            case let .update(_, deletions: deletions, insertions: insertions, modifications: modifications):
                
                if !deletions.isEmpty || !insertions.isEmpty {
                    self?.updateFirstLetters()
                    tableView.reloadData()
                } else {
                    for i in modifications {
                        if self?.filteredData[i].photos.count != self?.friendsData[i].photos.count {
                            break
                        } else if i == modifications.last {
                            self?.updateFirstLetters()
                            tableView.reloadData()
                        }
                    }
                    self?.friendsData = self?.filteredData
                }
                
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return FriendsController.firstLetters.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let firstLetter = FriendsController.firstLetters[section]
        var count: Int = 0
        for friend in filteredData {
            if String(friend.fullName.first!) == firstLetter {
                count += 1
            }
        }
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as! FriendsCell
        
        let firstLetter = FriendsController.firstLetters[indexPath.section]
        let startIndex = filteredData.firstIndex { String($0.fullName.first!) == firstLetter }
        
        let friendName = filteredData[startIndex! + indexPath.row].fullName
        let friendAvatar = filteredData[startIndex! + indexPath.row].avatar
        
        cell.configure(name: friendName, avatar: friendAvatar)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let firstLetter = FriendsController.firstLetters[indexPath.section]
        let startIndex = filteredData.firstIndex { String($0.fullName.first!) == firstLetter }
        
        FriendsController.selectedFriend = filteredData[startIndex! + indexPath.row]
        
        FriendsController.firstLetters = []
        
        searchControl.hideKeyboard()
        
        performSegue(withIdentifier: "toPhotos", sender: self)
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerReuseIdentifier) as! FriendsTableViewHeader
        
        header.configure(text: FriendsController.firstLetters[section])
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "toPhotos",
           let destination = segue.destination as? PhotosController {
            destination.title = FriendsController.selectedFriend!.fullName
        }
    }
    
    @objc func indexDidChange(_ sender: LetterControl) {
        let indexPath = IndexPath(row: 0, section: sender.selectedIndex!)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    @IBAction func textFieldDidChange(_ sender: Any) {
        
        guard let realm = try? Realm() else { return }
        
        filteredData = searchControl.searchText.isEmpty ? friendsData : realm.objects(User.self).filter("fullName CONTAINS[c] %@", searchControl.searchText)
        
        updateFirstLetters()
        tableView.reloadData()
    }
}
