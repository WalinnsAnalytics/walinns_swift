//
//  NewsItemCell.swift
//  RealmTasks
//
//  Created by Walinns Innovation on 21/03/18.
//  Copyright © 2018 Hossam Ghareeb. All rights reserved.
//

import UIKit

class NewsItemCell: UITableViewCell {
    func updateWithNewsItem(_ item:NewsItem) {
        self.textLabel?.text = item.title
        self.detailTextLabel?.text = DateParser.displayString(for: item.date)
    }
}
