//
//  NewsFeedTableViewController.swift
//  RealmTasks
//
//  Created by Walinns Innovation on 21/03/18.
//  Copyright © 2018 Hossam Ghareeb. All rights reserved.
//
import UIKit
import Foundation
import SafariServices

class NewsFeedTableViewController: UITableViewController {
    static let RefreshNewsFeedNotification = "RefreshNewsFeedNotification"
    let newsStore = NewsStore.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 75
        
        if let patternImage = UIImage(named: "pattern-grey") {
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor(patternImage: patternImage)
            tableView.backgroundView = backgroundView
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewsFeedTableViewController.receivedRefreshNewsFeedNotification(_:)), name: NSNotification.Name(rawValue: NewsFeedTableViewController.RefreshNewsFeedNotification), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func receivedRefreshNewsFeedNotification(_ notification: Notification) {
        DispatchQueue.main.async {
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension NewsFeedTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsStore.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsItemCell", for: indexPath) as! NewsItemCell
        cell.updateWithNewsItem(newsStore.items[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let item = newsStore.items[indexPath.row]
        if let url = URL(string: item.link), url.scheme == "https" {
            return true
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = newsStore.items[indexPath.row]
        
        if let url = URL(string: item.link) {
            let safari = SFSafariViewController(url: url)
            present(safari, animated: true, completion: nil)
        }
    }
}
