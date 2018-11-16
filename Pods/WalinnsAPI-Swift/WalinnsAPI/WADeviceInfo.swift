//
//  WADeviceInfo.swift
//  WalinnsAPI
//
//  Created by Walinns Innovation on 23/02/18.
//  Copyright © 2018 Walinns Innovation. All rights reserved.
//

import Foundation
import UIKit
import CoreTelephony
import CoreLocation
import SystemConfiguration
import UserNotifications
 
class WADeviceInfo {
    static let sharedInstance = WADeviceInfo()
    public var connectivty : String = ""
    var locationManager: CLLocationManager!
    
    func os_name() -> String {
        return "ios"
    }
    
    func os_version() -> String {
        
        return UIDevice.current.systemVersion
    }
    
    func app_version() -> String {
        
        return getVersion()
    }
    func getVersion() -> String {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return "no version info"
        }
        return version
    }
    
    func getSdkVersion() -> String {
       guard let version = Bundle(for:WADeviceInfo.self).infoDictionary?["CFBundleShortVersionString"] as? String else {
        return "no version info"
    }
     return version
    }
    
    func carrierName() -> String {
        // let networkInfoo = CTTelephonyNetworkInfo()
        //  let carrier = networkInfoo.subscriberCellularProvider
        // let carrierval  = carrier?.carrierName
        let carrierval = "No sim"
        return carrierval
    }
    
    func Connectivy_gen() -> String {
        let networkInfoo = CTTelephonyNetworkInfo()
        if(networkInfoo != nil){
            if(networkInfoo.currentRadioAccessTechnology != nil){
                let networkString = networkInfoo.currentRadioAccessTechnology!
                
                switch (networkString){
                case "CTRadioAccessTechnologyCDMA1x":
                    print("2g")
                    connectivty="2g"
                case  "CTRadioAccessTechnologyEdge" :
                    print("2g")
                    connectivty="2g"
                    
                case "CTRadioAccessTechnologyGPRS":
                    print("2g")
                    connectivty="2g"
                case "CTRadioAccessTechnologyeHRPD":
                    print("3g")
                    connectivty="3g"
                case "CTRadioAccessTechnologyHSDPA":
                    print("3g")
                    connectivty="3g"
                case "CTRadioAccessTechnologyHSUPA":
                    print("3g")
                    connectivty="3g"
                case "CTRadioAccessTechnologyLTE":
                    print("4g")
                    connectivty="4g"
                case "CTRadioAccessTechnologyCDMAEVDORev0":
                    print("3g")
                    connectivty="3g"
                case "CTRadioAccessTechnologyCDMAEVDORevA":
                    print("3g")
                    connectivty="3g"
                case "CTRadioAccessTechnologyCDMAEVDORevB":
                    print("3g")
                    connectivty="3g"
                case "CTRadioAccessTechnologyWCDMA":
                    print("3g")
                    connectivty="3g"
                default:
                    print("2g")
                    connectivty="2g"
                }
                
            }else{
                return "2g"
            }
            return connectivty
            
            
        }else{
            return "2g"
        }
        
    }
    
    func screenHeight() -> String {
        return String(describing: UIScreen.main.nativeBounds.height)
    }
    
    func screenWidth( ) -> String {
        return String(describing: UIScreen.main.nativeBounds.width)
    }
    
    func screendpi() -> String {
        let ppi = UIScreen.main.bounds       // #> 326]
        return String(describing: ppi)
    }
    
    func age() -> String {
        return "min 21"
    }
    
    func language( ) -> String {
        let pre = Locale.preferredLanguages[0]
        
        return String(pre)
        
    }
    
    
    
    func deviceLanguage() -> String {
        let pre = Locale.preferredLanguages[0]
        return String(pre)
    }
    
    func location( ) -> String {
        let countryCode = NSLocale.current.regionCode
        print("Country code" , countryCode)
        
        return countryCode!
        
    }
    
    @available(iOS 10.0, *)
    func notifyStatus() -> String {
 
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                // Notifications are allowed
                print("push enabled or not","Notifications are allowed")
                WAUtils.init().save_pref(key : "notify_status" , value:"true" )
            } else {
                // Either denied or notDetermined
                print("push enabled or not","Either denied or notDetermined")
                WAUtils.init().save_pref(key : "notify_status" , value:"false" )

            }

            }

      
//        let center = UNUserNotificationCenter.current()
//        center.getNotificationSettings { (settings) in
//            if(settings.authorizationStatus == .authorized)
//            {
//                print("Push authorized")
//                notify_status = "true"
//            }
//            else
//            {
//                print("Push not authorized")
//                notify_status = "false"
//            }
//        }
        return WAUtils.init().read_pref(key: "notify_status")
    }
    
    func city() -> String {
        var city_ = "NA"
        if(WAUtils.init().read_pref(key: "city") != nil){
            city_ = WAUtils.init().read_pref(key: "city");
        }
        
        print("Location val city:" , city_)
        return city_
    }
    
    func state() -> String {
        var state_ = "NA"
        if(WAUtils.init().read_pref(key: "state") != nil){
            state_ = WAUtils.init().read_pref(key: "state");
        }
        
        print("Location val city:" , state_)
        return state_
    }
    
    func email() -> String {
        return "example@gmail.com"
    }
    
    func device_model() -> String {
//        var systemInfo = utsname()
//        uname(&systemInfo)
//        let size = MemoryLayout<CChar>.size
//        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
//            $0.withMemoryRebound(to: CChar.self, capacity: size) {
//                String(cString: UnsafePointer<CChar>($0))
//            }
//        }
//        if let model = String(validatingUTF8: modelCode) {
//
//            return String(model)
//        }else{
//            return "no model"
//        }
        let modelName = UIDevice.modelName
        
        return modelName

    }
    func checkWiFi() -> String {
        
        let networkStatus = Reachability().connectionStatus()
        switch networkStatus {
        case .Unknown, .Offline:
            print("Connected via No internet")
            return "No Internet"
        case .Online(.WWAN):
            print("Connected via WWAN")
            return "Mobile Data"
        case .Online(.WiFi):
            print("Connected via WiFi")
            return "WiFi"
        }
        
        
        
        
    }
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
   
}
public extension UIDevice {
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
    
}
