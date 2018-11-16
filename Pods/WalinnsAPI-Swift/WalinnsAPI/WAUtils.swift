//
//  WAUtils.swift
//  WalinnsAPI
//
//  Created by Walinns Innovation on 23/02/18.
//  Copyright © 2018 Walinns Innovation. All rights reserved.
//

import Foundation
import UIKit

public class WAUtils {
    
    func getCurrentUtc() -> String {
        let currentDateTime = Date()
        // print("Current_date_time", currentDateTime)
        let dt = String(describing: currentDateTime)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        let someDateTime = formatter.date(from: dt)
        // print("Current_date_time2", someDateTime)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        print("Current_date_time3", formatter.string(from: someDateTime!))
        return  formatter.string(from: someDateTime!)
    }
    
    func save_pref(key : String , value : String) {
        let preferences = UserDefaults.standard
        preferences.set(value, forKey: key)
        preferences.synchronize()
    }
    
    func read_pref(key : String) -> String {
        let preferences = UserDefaults.standard
        if preferences.object(forKey: key) == nil {
            //  Doesn't exist
        } else {
            let currentLevel = preferences.string(forKey: key)
            return currentLevel!
        }
        return "null"
    }
    func UTCToLocal(date:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let newDate = dateFormatter.string(from: dt!) //pass Date here
        let date_cur = dateFormatter.date(from: newDate)
        return date_cur!
    }
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    func calcAge(birthday: String) -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd/MM/yyyy"
        let birthdayDate = dateFormater.date(from: birthday)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
        let age = calcAge.year
        return age!
    }
    
}

