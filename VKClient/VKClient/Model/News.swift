//
//  News.swift
//  VK Client
//
//  Created by Артём Калинин on 24.03.2021.
//

import UIKit

class News {
    
    var name: String
    var profileImage: UIImage
    var date: String
    var wallText: String?
    var images: [UIImage]?
    
    init(name: String, profileImage: UIImage, date: String, wallText: String?, images: [UIImage]?) {
        self.name = name
        self.profileImage = profileImage
        self.date = date
        self.wallText = wallText
        self.images = images
    }
}

extension News {
    static func getData() -> [News] {
        let news0 = News(name: "Артём Калинин", profileImage: UIImage(named: "Артём")!,
                         date: "13.01.2021", wallText: nil,images: [UIImage(named: "deer1")!, UIImage(named: "deer2")!])
        
        let news1 = News(name: "Сергей Волченков", profileImage: UIImage(named: "Сергей")!, date: "25.02.2021", wallText: "Три входа в Йеллоустонский национальный парк откроются для посетителей в понедельник, 1 июня, так как штат Монтана переходит ко второму этапу перезапуска экономики после остановок из-за коронавируса.", images: nil)
        
        let news2 = News(name: "Виктория Афанасьева", profileImage: UIImage(named: "Виктория")!, date: "02.03.2021", wallText: "Красавчик Хью Грант сегодня отмечает свое 60-летие!\nОн не только похититель сердец в классических мелодрамах, но еще и замечательный рассказчик.", images: [UIImage(named: "hugh1")!,
        UIImage(named: "hugh2")!,
        UIImage(named: "hugh3")!,
        UIImage(named: "hugh4")!])
        
        let news3 = News(name: "Кирилл Корнющенков", profileImage: UIImage(named: "Кирилл")!, date: "14.05.2021",
                         wallText: nil, images: nil)
        
        return [news0, news1, news2, news3]
    }
}
