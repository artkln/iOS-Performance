//
//  NewsController.swift
//  VK Client
//
//  Created by Артём Калинин on 24.03.2021.
//

import UIKit

class NewsController: UITableViewController {

    var newsData = [News]()
    private let headerReuseIdentifier = "NewsHeader"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(red: 0.84, green: 0.81, blue: 0.76, alpha: 1.00)
        
        newsData = News.getData()
        
        self.tableView.register(UINib(nibName: "NewsTableViewHeader", bundle: nil),
                                forHeaderFooterViewReuseIdentifier: headerReuseIdentifier)
        self.tableView.register(UINib.init(nibName: "FullNewsCell", bundle: nil),
                                forCellReuseIdentifier: "FullNewsCell")
        self.tableView.register(UINib.init(nibName: "EmptyNewsCell", bundle: nil),
                                forCellReuseIdentifier: "EmptyNewsCell")
        self.tableView.register(UINib.init(nibName: "TextNewsCell", bundle: nil),
                                forCellReuseIdentifier: "TextNewsCell")
        self.tableView.register(UINib.init(nibName: "ImageNewsCell", bundle: nil),
                                forCellReuseIdentifier: "ImageNewsCell")
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return newsData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let wallText = newsData[indexPath.section].wallText,
           let images = newsData[indexPath.section].images {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FullNewsCell", for: indexPath) as! FullNewsCell
            cell.configure(wallText: wallText, images: images)
            return cell
            
        } else if let wallText = newsData[indexPath.section].wallText {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextNewsCell", for: indexPath) as! TextNewsCell
            cell.configure(wallText: wallText)
            return cell
            
        } else if let images = newsData[indexPath.section].images {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageNewsCell", for: indexPath) as! ImageNewsCell 
            cell.configure(images: images)
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyNewsCell", for: indexPath) as! EmptyNewsCell
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerReuseIdentifier) as! NewsTableViewHeader
        
        header.configure(name: newsData[section].name, profileImage: newsData[section].profileImage, date: newsData[section].date)
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 73
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
