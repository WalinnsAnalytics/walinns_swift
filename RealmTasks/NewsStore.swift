//
//  NewsStore.swift
//  RealmTasks
//
//  Created by Walinns Innovation on 21/03/18.
//  Copyright © 2018 Hossam Ghareeb. All rights reserved.
//

import UIKit

class NewsStore: NSObject {
    static let shared = NewsStore()
    
    var items: [NewsItem] = []
    
    override init() {
        super.init()
        self.loadItemsFromCache()
    }
    
    func add(item: NewsItem) {
        items.insert(item, at: 0)
        saveItemsToCache()
    }
}


// MARK: Persistance
extension NewsStore {
    func saveItemsToCache() {
        NSKeyedArchiver.archiveRootObject(items, toFile: itemsCachePath)
    }
    
    func loadItemsFromCache() {
        if let cachedItems = NSKeyedUnarchiver.unarchiveObject(withFile: itemsCachePath) as? [NewsItem] {
            items = cachedItems
        }
    }
    
    var itemsCachePath: String {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent("news.dat")
        return fileURL.path
    }
}

