//
//  HomeViewController.swift
//  RealmTasks
//
//  Created by Walinns Innovation on 08/02/18.
//  Copyright © 2018 Hossam Ghareeb. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import WalinnsAPI_Swift

class HomeViewController: UIViewController {

    @IBOutlet weak var image_view: UIImageView!
    @IBOutlet weak var login_fb: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        //WalinnsTracker.initialize(project_token: "682bee57181363eb55d73337faa3eeb11")
       
        WalinnsApi.initialize(project_token: "682bee57181363eb55d73337faa3eeb1")
       
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let imagee = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        image_view.image = imagee
//        var imagesToShare = [AnyObject]()
//        imagesToShare.append(image!)
//
//        let activityViewController = UIActivityViewController(activityItems: imagesToShare , applicationActivities: nil)
//        activityViewController.popoverPresentationController?.sourceView = self.view
//        present(activityViewController, animated: true, completion: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func login_action(_ sender: Any) {
        WalinnsApi.track(screen_name: "HomeViewController")
        WalinnsApi.track(event_type : "LoginButton",event_name : "Login")
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "TaskListsViewController") as! TaskListsViewController
        let navController = UINavigationController(rootViewController: VC1) // Creating a navigation controller with VC1 at the root of the navigation stack.
        self.present(navController, animated:true, completion: nil)
  //      let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
//        fbLoginManager.logIn(withReadPermissions: ["user_birthday","public_profile","user_friends","email"], from: self) { (result, error) in
//            if (error == nil){
//                let fbloginresult : FBSDKLoginManagerLoginResult = result!
//                if fbloginresult.grantedPermissions != nil {
//                    print("Fb login result :" , fbloginresult.token.tokenString);
//                    self.getFBUserData()
//                    //fbLoginManager.logOut()
//
//                }
//            }
//        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email, gender, birthday"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    print("Current user data :" , result)
//                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TaskListsViewController") as! TaskListsViewController
//                    self.navigationController?.pushViewController(nextViewController, animated: true)
                    let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "TaskListsViewController") as! TaskListsViewController
                    let navController = UINavigationController(rootViewController: VC1) // Creating a navigation controller with VC1 at the root of the naviga      tion stack.
                    self.present(navController, animated:true, completion: nil)
                    
                   // WalinnsTracker.sendProfile(user_profile: result as! NSDictionary)
                }else{
                    print("Current user data error :" , error ?? 1)
                }
            })
        }
    }
//    var startPoint: CGPoint?
//    var touchTime = NSDate()
//    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard touches.count == 1 else {
//            return
//        }
//        if let touch = touches.first {
//            startPoint = touch.location(in: view)
//            touchTime = NSDate()
//
//            print("Touch point :" , startPoint)
//        }
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        defer {
//            startPoint = nil
//        }
//        guard touches.count == 1, let startPoint = startPoint else {
//            return
//        }
//        if let touch = touches.first {
//            let endPoint = touch.location(in: view)
//            //Calculate your vector from the delta and what not here
//            let direction = CGVector(dx: endPoint.x - startPoint.x, dy: endPoint.y - startPoint.y)
//            let elapsedTime = touchTime.timeIntervalSinceNow
//            let angle = atan2f(Float(direction.dy), Float(direction.dx))
//        }
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        startPoint = nil
//    }
}
