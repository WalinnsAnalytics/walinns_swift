//
//  ApiClient.swift
//  WalinnsAPI
//
//  Created by Walinns Innovation on 23/02/18.
//  Copyright © 2018 Walinns Innovation. All rights reserved.
//

import Foundation
import UIKit


class ApiClient : NSObject{
    public var flagval : String = "na"
    struct singleton {
        static let sharedInstance = ApiClient()
        
    }
    func varsharedInstance(suburl : String ,json : String) -> NSObject {
        
        postRequest(api: suburl , jsonString: json)
        return (singleton.sharedInstance)
    }
    func varsharedInstance(suburl : String ,json : String , flag_status : String) -> NSObject {
        print("Flag Status response..."  ,  flag_status)
        flagval = flag_status
        postRequest(api: suburl , jsonString: json)
        return (singleton.sharedInstance)
    }
    
    var url_base = "https://wa.track.app.walinns.com/"
    func postRequest (api: String,jsonString : String, parameters: [String: Any]? = nil) {
        
        guard let destination = URL(string: url_base + api) else { return }
        print("project_url :",jsonString)
        var request = URLRequest(url: destination)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(WAUtils.init().read_pref(key: "token"), forHTTPHeaderField: "Authorization")
        request.httpBody = jsonString.data(using: .utf8)
        request.timeoutInterval = 150
        print("project_token :",WAUtils.init().read_pref(key: "token"))
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    if (json["response"]) != nil {
                        Logger.e(messing: "Flag Status response :"+api+"   flag..: "+self.flagval)
                        if(self.flagval == "na"){
                            self.api_call(falg_status: api)
                        }else{
                            self.api_call(falg_status: self.flagval)
                        }
                    }
                    else {
                        print("Http_response_","ABCD")
                    }
                } catch {
                    print("Http_response_error",error)
                }
            } else {
                print("Http_response_error1",error ?? "")
                self.api_call(falg_status: "response_error")
            }
        }
        task.resume()
        print(url_base + api)
    }
    
    func api_call(falg_status : String) {
        switch falg_status {
        case "devices":
            if( WAUtils.init().read_pref(key: "token") != nil){
                WAApiclient.init(token: WAUtils.init().read_pref(key: "token")).appUserStatus(app_status: "yes")
                WAUtils.init().save_pref(key : "device_status" , value:"success" )
                if(WAUtils.init().read_pref(key: "default_event") != nil && WAUtils.init().read_pref(key: "default_event") == "success" ){
                }else{
                    
                    DispatchQueue.global(qos: .background).async {
                       
                        
                        DispatchQueue.main.async {
                             print("App Install ","called")
                            WAApiclient.init(token: WAUtils.init().read_pref(key: "token")).eventTrack(event_type: "default_event", event_name:  "App Install")
                            
                            WAApiclient.init(token: WAUtils.init().read_pref(key: "token")).eventTrack(event_type: "default_event", event_name:  "App Launch")
                            WAUtils.init().save_pref(key : "default_event" , value:"success" )
                        }
                    }
               
                }
            }
            
            break
            //        case "screenView":
            //
            //            break
            //        case "events":
            //
            //            break
            //        case "session":
            //            print("Flag Status session" , falg_status)
            //
            //
            //            break
            //        case "fetchAppUserDetail":
            //            print("Flag Status user" , falg_status)
            //
            //            break
            //        case "fetch_no":
            //
            //             print("Flag Status fetch_no" , falg_status)
            //             Utils.init().save_pref(key: "session" , value: "end")
            //            break
            //        case "response_error":
            //
            //            break
            
        default: break
            
        }
        
    }
    
    
    
    
}


