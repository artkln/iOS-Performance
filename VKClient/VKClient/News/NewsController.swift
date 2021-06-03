//
//  NewsController.swift
//  VK Client
//
//  Created by Артём Калинин on 24.03.2021.
//

import UIKit

class NewsController: UITableViewController {

    var newsData = [News]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(red: 0.84, green: 0.81, blue: 0.76, alpha: 1.00)
        
        newsData = News.getData()
        
        self.tableView.register(UINib.init(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell

        let name = newsData[indexPath.row].name
        let profileImage = newsData[indexPath.row].profileImage
        let date = newsData[indexPath.row].date
        let wallText = newsData[indexPath.row].wallText
        let images = newsData[indexPath.row].images

        cell.configure(name: name, profileImage: profileImage, date: date, wallText: wallText, images: images)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
