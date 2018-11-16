//
//  WAApiclient.swift
//  WalinnsAPI
//
//  Created by Walinns Innovation on 23/02/18.
//  Copyright © 2018 Walinns Innovation. All rights reserved.
//

import Foundation
import UIKit


class WAApiclient {
    
    var project_token : String
    var device_id = UIDevice.current.identifierForVendor!.uuidString
    var last_name = "NA"
    var sdk_version = "false"
    var timer: Timer!
    var sessionStartTime: TimeInterval = Date().timeIntervalSince1970
    var sessionLength: TimeInterval = 0
    var sessionEndTime: TimeInterval = 0
    var start_time : String = WAUtils.init().getCurrentUtc()
    var end_time : String = ""
    var device_type : String = "iPhone"
    
    
    
    init(token :String ) {
        self.project_token = token
        if(UserDefaults.standard.string(forKey: device_id) != nil){
            print("DEVICE ID second TIME: " , self.device_id , "old.." , UserDefaults.standard.string(forKey: device_id))
            
        }else{
            UserDefaults.standard.set(self.device_id, forKey: "device_id")
            UserDefaults.standard.synchronize()
            print("DEVICE ID FIRST TIME: " , self.device_id)
        }
        
    }
    
    
    func DeviceReq(jsonobject : NSDictionary) {
        let jsonObjectt : NSMutableDictionary = NSMutableDictionary()
         
        print("Location val inside:" , WADeviceInfo.init().getSdkVersion())
        print("Location val inside:" , jsonobject.value(forKey: "city"))
        if(jsonobject.value(forKey: "email") != nil  ){
            jsonObjectt.setValue(jsonobject.value(forKey: "gender"), forKey: "gender")
            jsonObjectt.setValue(jsonobject.value(forKey: "email"), forKey: "email")
            jsonObjectt.setValue(WAUtils.init().calcAge(birthday : jsonobject.value(forKey: "dob") as! String), forKey: "age")
            
        }else{
            jsonObjectt.setValue("NA", forKey: "gender")
            jsonObjectt.setValue("NA", forKey: "email")
            jsonObjectt.setValue("NA", forKey: "age")
        }
        
        if(jsonobject.value(forKey: "city") != nil){
            jsonObjectt.setValue(jsonobject.value(forKey: "city"), forKey: "city")
        }else{
            jsonObjectt.setValue("NA", forKey: "city")
        }
        if(jsonobject.value(forKey: "regionName") != nil){
            jsonObjectt.setValue(jsonobject.value(forKey: "regionName"), forKey: "state")
        }else{
            jsonObjectt.setValue("NA", forKey: "state")
        }
        if(jsonobject.value(forKey: "countryCode") != nil){
            jsonObjectt.setValue(jsonobject.value(forKey: "countryCode"), forKey: "country")
        }else{
            jsonObjectt.setValue(WADeviceInfo.init().location(), forKey: "country")
        }
        if(jsonobject.value(forKey: "name") != nil){
            jsonObjectt.setValue(jsonobject.value(forKey: "name"), forKey: "First_name")
            jsonobject.setValue("NA", forKey: "Last_name")
        }else{
            jsonObjectt.setValue("NA", forKey: "First_name")
            jsonObjectt.setValue(last_name, forKey: "Last_name")

        }
        
         jsonObjectt.setValue(device_id, forKey: "device_id")
         jsonObjectt.setValue(WADeviceInfo.init().device_model(), forKey: "device_model")
         jsonObjectt.setValue(WADeviceInfo.init().os_name(), forKey: "os_name")
         jsonObjectt.setValue(WADeviceInfo.init().os_version(), forKey: "os_version")
         jsonObjectt.setValue(WADeviceInfo.init().app_version(), forKey: "app_version")
         jsonObjectt.setValue(WADeviceInfo.init().checkWiFi(), forKey: "connectivity")
         jsonObjectt.setValue(WADeviceInfo.init().carrierName(), forKey: "carrier")
         jsonObjectt.setValue("false", forKey: "play_service")
         jsonObjectt.setValue("false", forKey: "bluetooth")
         jsonObjectt.setValue(WADeviceInfo.init().screendpi(), forKey: "screen_dpi")
         jsonObjectt.setValue(WADeviceInfo.init().screenHeight(), forKey: "screen_height")
         jsonObjectt.setValue(WADeviceInfo.init().screenWidth(), forKey: "screen_width")
         jsonObjectt.setValue(WADeviceInfo.init().language(), forKey: "app_language")
         jsonObjectt.setValue(WAUtils.init().getCurrentUtc(),forKey: "date_time")
         jsonObjectt.setValue(WADeviceInfo.init().getSdkVersion(), forKey: "sdk_version")
         jsonObjectt.setValue(WADeviceInfo.init().deviceLanguage(), forKey: "language")
         
        if #available(iOS 10.0, *) {
            // use the feature only available in iOS 10
            // for ex. UIStackView
            jsonObjectt.setValue(WADeviceInfo.init().notifyStatus(), forKey: "notify_status")

        } else {
            // or use some work around
            jsonObjectt.setValue("yes", forKey: "notify_status")

        }
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            print("Device type value","iPad")
            device_type = "iPad"
            jsonObjectt.setValue(device_type, forKey: "device_type")
        case .phone:
            print("Device type value","iPhone")
            device_type = "iPhone"
            jsonObjectt.setValue(device_type, forKey: "device_type")
        case .tv:
            print("TV")
            device_type = "TV"
            jsonObjectt.setValue(device_type, forKey: "device_type")
        case .carPlay:
            print("Device type value","carPlay")
            device_type = "carPlay"
            jsonObjectt.setValue(device_type, forKey: "device_type")
        default: break;
        }
         jsonObjectt.setValue("Apple", forKey: "device_manufacture")
         convertToJson(json_obj : jsonObjectt ,service_name : "devices" )
        print("WalinnsTrackerClient Device:", jsonObjectt )

        
       // jsonObjectt.setValue(device_type, forKey: "device_type")
    }
    
    public func eventTrack(event_type : String, event_name : String) {
        let jsonObject : NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(device_id, forKey: "device_id")
        jsonObject.setValue(event_name, forKey: "event_name")
        jsonObject.setValue(event_type, forKey: "event_type")
        jsonObject.setValue(WAUtils.init().getCurrentUtc(), forKey: "date_time")
        print("WalinnsTrackerClient event:", jsonObject)
        convertToJson(json_obj : jsonObject ,service_name : "events" )
        
    }
    public func screenTrack(screen_name : String) {
        let jsonObject : NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(device_id, forKey: "device_id")
        jsonObject.setValue(screen_name, forKey: "screen_name")
        jsonObject.setValue(WAUtils.init().getCurrentUtc(), forKey: "date_time")
        print("WalinnsTrackerClient session:", jsonObject )
        convertToJson(json_obj : jsonObject ,service_name : "screenView" )
        
    }
    
    func convertToJson(json_obj : NSMutableDictionary , service_name : String) {
        //print("JSON OBJEC" , jsonObject)
        let jsonData: NSData
        do {
         jsonData = try JSONSerialization.data(withJSONObject: json_obj, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
            let jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
            api_name(type_name: service_name , jsonstring:jsonString , flag: "na")


        } catch _ {
            print ("JSON Failure")

        }

    }
    func convertToJson(json_obj : NSMutableDictionary , service_name : String , flag_status : String) {
        //print("JSON OBJEC" , jsonObject)
        let jsonData: NSData
        
        do {
            jsonData = try JSONSerialization.data(withJSONObject: json_obj, options: JSONSerialization.WritingOptions()) as NSData
            let jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
            api_name(type_name: service_name , jsonstring:jsonString , flag: flag_status)
            
        } catch _ {
            print ("JSON Failure")
            
        }
    }
    
    func api_name(type_name : String , jsonstring : String , flag : String) {
        switch type_name {
        case "devices":
            ApiClient().varsharedInstance(suburl: "devices" ,json : jsonstring);
            break
        case "screenView":
            ApiClient().varsharedInstance(suburl: "screenView" ,json : jsonstring);
            break
        case "events":
            ApiClient().varsharedInstance(suburl: "events" ,json : jsonstring);
            break
        case "session":
            ApiClient().varsharedInstance(suburl: "session" ,json : jsonstring);
            break
        case "fetchAppUserDetail":
            print("Fetch app user details :" , jsonstring)
            if(flag == "fetch_no"){
                ApiClient().varsharedInstance(suburl: "fetchAppUserDetail" ,json : jsonstring , flag_status: flag);
            }else{
                ApiClient().varsharedInstance(suburl: "fetchAppUserDetail" ,json : jsonstring);
            }
            break
            
        case "uninstallcount":
            ApiClient().varsharedInstance(suburl: "uninstallcount" ,json : jsonstring, flag_status: flag);
            break
            
        default: break
            
        }
        
    }
    
    
    
    func roundOneDigit(num: TimeInterval) -> TimeInterval {
        return round(num * 10.0) / 10.0
    }
    public func sessionTrack(start_timee : String , end_time : String){
        if (WAUtils.init().read_pref(key: "device_status") != nil){
            let terminationDuration = WAUtils.init().UTCToLocal(date: end_time).timeIntervalSince(WAUtils.init().UTCToLocal(date: start_timee))
            
            let jsonObject : NSMutableDictionary = NSMutableDictionary()
            jsonObject.setValue(device_id, forKey: "device_id")
            jsonObject.setValue(WAUtils.init().stringFromTimeInterval(interval: terminationDuration), forKey: "session_length")
            jsonObject.setValue(start_timee, forKey: "start_time")
            jsonObject.setValue(end_time, forKey: "end_time")
            print("WalinnsTrackerClient session:", jsonObject )
            convertToJson(json_obj : jsonObject ,service_name : "session" )
        }
        
    }
    
    public func appUserStatus(app_status : String){
        
        let jsonObject : NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(device_id, forKey: "device_id")
        jsonObject.setValue(app_status, forKey: "active_status")
        jsonObject.setValue(WAUtils.init().getCurrentUtc(), forKey: "date_time")
        
        if(app_status == "yes"){
            convertToJson(json_obj : jsonObject ,service_name : "fetchAppUserDetail" )
        }else{
            if (WAUtils.init().read_pref(key: "device_status") != nil){
                convertToJson(json_obj : jsonObject ,service_name : "fetchAppUserDetail", flag_status : "fetch_no")
            }
        }
    }
    public func appUninstallCount(pushToken : String){
        let bundleIdentifier =  Bundle.main.bundleIdentifier
        print("Bundle identifier :" , bundleIdentifier)
        let jsonObject : NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(device_id, forKey: "device_id")
        jsonObject.setValue(bundleIdentifier, forKey: "package_name")
        jsonObject.setValue(pushToken, forKey: "push_token")
        jsonObject.setValue(WAUtils.init().getCurrentUtc(), forKey: "date_time")
        
        print("Bundle identifier object:" , jsonObject)
        convertToJson(json_obj : jsonObject ,service_name : "uninstallcount" )
    }
    
    func crashStatus(crash_reason : String) {
        let jsonObject : NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(device_id, forKey: "device_id")
        jsonObject.setValue(crash_reason, forKey: "reason")
        jsonObject.setValue(WAUtils.init().getCurrentUtc(), forKey: "date_time")
    }
//    func handlepush(_ userInfo: [AnyHashable : Any]) -> DeeplinkType? {
//        print("image",userInfo)
//        if let data = userInfo["data"] as? [String: Any] {
//            if let messageId = data["messageId"] as? String {
//                return DeeplinkType.messages(.details(id: messageId))
//            }
//        }
//        return nil
//    }
    
}

