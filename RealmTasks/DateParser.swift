//
//  DateParser.swift
//  RealmTasks
//
//  Created by Walinns Innovation on 21/03/18.
//  Copyright © 2018 Hossam Ghareeb. All rights reserved.
//

import UIKit

class DateParser: NSObject {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()
    
    //Wed, 04 Nov 2015 21:00:14 +0000
    static func dateWithPodcastDateString(_ dateString: String) -> Date? {
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        return dateFormatter.date(from: dateString)
    }
    
    static func displayString(for date: Date) -> String {
        dateFormatter.dateFormat = "HH:mm MMMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
}

