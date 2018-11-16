//
//  NewsItem.swift
//  RealmTasks
//
//  Created by Walinns Innovation on 21/03/18.
//  Copyright © 2018 Hossam Ghareeb. All rights reserved.
//

import UIKit

final class NewsItem: NSObject {
    let title: String
    let date: Date
    let link: String
    
    init(title: String, date: Date, link: String) {
        self.title = title
        self.date = date
        self.link = link
    }
    
    class func makeNewsItem(_ notificationDictionary: [String: AnyObject]) -> NewsItem? {
        if let news = notificationDictionary["alert"] as? String,
            let url = notificationDictionary["link_url"] as? String {
            let date = Date()
            
            let newsItem = NewsItem(title: news, date: date, link: url)
            let newsStore = NewsStore.shared
            newsStore.add(item: newsItem)
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: NewsFeedTableViewController.RefreshNewsFeedNotification), object: self)
            return newsItem
        }
        return nil
    }
}

extension NewsItem: NSCoding {
    struct CodingKeys {
        static let Title = "title"
        static let Date = "date"
        static let Link = "link"
    }
    
    convenience init?(coder aDecoder: NSCoder) {
        if let title = aDecoder.decodeObject(forKey: CodingKeys.Title) as? String,
            let date = aDecoder.decodeObject(forKey: CodingKeys.Date) as? Date,
            let link = aDecoder.decodeObject(forKey: CodingKeys.Link) as? String {
            self.init(title: title, date: date, link: link)
        } else {
            return nil
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: CodingKeys.Title)
        aCoder.encode(date, forKey: CodingKeys.Date)
        aCoder.encode(link, forKey: CodingKeys.Link)
    }
}
