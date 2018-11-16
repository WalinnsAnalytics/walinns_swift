//
//  WalinnsApi.swift
//  WalinnsAPI
//
//  Created by Walinns Innovation on 23/02/18.
//  Copyright © 2018 Walinns Innovation. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import UserNotifications



public class WalinnsApi : NSObject{
    
    //sharedInstance
    public static let sharedInstance = WalinnsApi()
 
    public var start_time = WAUtils.init().getCurrentUtc()
    public var end_time = "na"
    public var pushToken = "na"
    public var profile : NSMutableDictionary? = nil
    public var exception_ : String = "na"
    
    

    
    public static func initialize(project_token : String)  {
        WAUtils.init().save_pref(key: "token", value:project_token)
        locationIP()
        NSSetUncaughtExceptionHandler { exception in
            print("EXCEPTION CAUGHT HERE....")
            //  CrashStatus(crash_reason: String(describing: exception))
        }
        sharedInstance.start()
        print("WlinnsTrackerClient" + project_token , self)
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert , .badge , .sound], completionHandler: { didAllow , Error in})
        } else {
            // Fallback on earlier versions
        }
        NotificationCenter.default.addObserver(WalinnsApi.sharedInstance, selector: #selector(sharedInstance.appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        
         NotificationCenter.default.addObserver(WalinnsApi.sharedInstance, selector: #selector(sharedInstance.appMovedToForeground), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
        WAApiclient.init(token: project_token)
        
    }
    @objc func appMovedToForeground(){
        print("WalinnsTrackerClient foreground!" , "self.end_time")
        if (WAUtils.init().read_pref(key: "device_status") != nil && WAUtils.init().read_pref(key: "device_status") == "success"){
             print("App Install ","called......")
            WAApiclient.init(token: WAUtils.init().read_pref(key: "token")).eventTrack(event_type : "default_event" ,event_name: "App Launch" )
            WAApiclient.init(token: WAUtils.init().read_pref(key: "token")).eventTrack(event_type : "default_event" ,event_name: "App Screen Viewed" )
        }
    }
    @objc func appMovedToBackground(){
        DispatchQueue.global(qos: .background).async {
            
            DispatchQueue.main.async {
                self.end_time = WAUtils.init().getCurrentUtc()
                print("WalinnsTrackerClient end time!" , self.end_time )
                if(WAUtils.init().read_pref(key: "token") != nil ){
                    WAApiclient.init(token: WAUtils.init().read_pref(key: "token")).sessionTrack(start_timee : self.start_time ,end_time: self.end_time)
                    WAApiclient.init(token: WAUtils.init().read_pref(key: "token")).appUserStatus(app_status: "no")
                    WAApiclient.init(token: WAUtils.init().read_pref(key: "token")).appUninstallCount(pushToken: self.pushToken)
                }
            }
        }
    }
    
    
    public func start()  {
        
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            
            DispatchQueue.main.async {
                print("WalinnsTrackerClient start time" , WalinnsApi.sharedInstance.profile)
                let dummy : NSMutableDictionary = NSMutableDictionary()
                dummy.setValue(nil, forKey: "email")
                if(WAUtils.init().read_pref(key: "token") != nil ){
                    if(WalinnsApi.sharedInstance.profile != nil ){
                        WAApiclient.init(token: WAUtils.init().read_pref(key: "token")).DeviceReq(jsonobject: WalinnsApi.sharedInstance.profile!)
                    }else{
                        WAApiclient.init(token: WAUtils.init().read_pref(key: "token")).DeviceReq(jsonobject: dummy)
                    }
                }
                
            }
        }
        
        
    }
    public static func track(event_type : String,event_name : String){
        print("event_data_token:" , WAUtils.init().read_pref(key: "token"))
        if (WAUtils.init().read_pref(key: "device_status") != nil){
            WAApiclient.init(token: WAUtils.init().read_pref(key: "token")).eventTrack(event_type : event_type ,event_name: event_name )
        }
        
    }
    
    public static func track(screen_name : String){
        
        if (WAUtils.init().read_pref(key: "device_status") != nil){
            WAApiclient.init(token: WAUtils.init().read_pref(key: "token")).screenTrack(screen_name : screen_name)
        }
        
//        let takeoverNotificationVC = NotificationViewController()
//        takeoverNotificationVC.delegate = self
//        takeoverNotificationVC.show(animated: true)
//        self.navigationController!.pushViewController(NotificationViewController(nibName: "NotificationViewController", bundle: nil), animated: true)
//        let modalView = NotificationViewController(frame: self.view.bounds)


       
    }
    public static func sendPushToken(push_token : String){
        if(push_token != nil){
            print("send push token :" , push_token , ".......", WAUtils.init().read_pref(key: "token"))
            WalinnsApi.sharedInstance.pushToken = push_token
        }
    }
    public static func sendProfile(user_profile : NSDictionary){
        print("Json object for userprofile ", user_profile)
        WalinnsApi.sharedInstance.profile = user_profile.mutableCopy() as! NSMutableDictionary
        sharedInstance.start()
    }
    
    public static func CrashStatus(crash_reason : String){
        
        WAApiclient.init(token: WAUtils.init().read_pref(key: "token")).crashStatus(crash_reason: crash_reason)
    }
    
    public static func handleNotification(_ userInfo: [AnyHashable : Any]){
        
       // WAApiclient.init(token: WAUtils.init().read_pref(key: "token")).handlepush(userInfo)
    }
    
    private static func locationIP( ){
        let url     = URL(string: "http://ip-api.com/json")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        DispatchQueue.main.async {
            URLSession.shared.dataTask(with: request as URLRequest, completionHandler:
                { (data, response, error) in
                    DispatchQueue.main.async
                        {
                            if let content = data
                            {
                                do
                                {
                                    if let object = try JSONSerialization.jsonObject(with: content, options: .allowFragments) as? NSDictionary
                                    {
                                        //completion(object, error)
                                        print("Location val :" , object)
                                        if let obj = object as? NSDictionary {
 
                                            if(WAUtils.init().read_pref(key: "token") != nil ){
                                  WAApiclient.init(token: WAUtils.init().read_pref(key: "token")).DeviceReq(jsonobject: obj)
                                            }
                                        }
 
                                      }
                                    else
                                    {
                                        // TODO: Create custom error.
                                        //completion(nil, nil)
                                        print("Location val :" , "error 1")
                                    }
                                }
                                catch
                                {
                                    // TODO: Create custom error.
                                    // completion(nil, nil)
                                    print("Location val :" , "error 2")
                                }
                            }
                            else
                            {
                                print("Location val :" , error)
                            }
                    }
            }).resume()
        }
    }
    
    @available(iOS 10.0, *)
    public func pushData(notificationcontent : UNMutableNotificationContent){
        if #available(iOS 10.0, *) {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: "SimplifiedNotification", content: notificationcontent, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
}
