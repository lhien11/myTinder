//
//  SignUpViewController.swift
//  ParseStarterProject
//
//  Created by Hien Le on 10/24/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    @IBOutlet var userImage: UIImageView!
    
    @IBOutlet var interestedInWomen: UISwitch!
    @IBAction func signUp(sender: AnyObject) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, gender"])
        graphRequest.startWithCompletionHandler ({ (connection, result, error) -> Void in
            if error != nil {
                print(error)
            } else if let result = result {
                //print(result)
                PFUser.currentUser()?["gender"] = result["gender"]
                PFUser.currentUser()?["name"] = result["name"]
                
                PFUser.currentUser()?.save()
                
                let userId = result["id"] as! String
                let facebookProfilePictureUrl = "https://graph.facebook.com/" + userId + "/picture?type=large"
                
                if let fbpicUrl = NSURL(string: facebookProfilePictureUrl){
                    if let data = NSData(contentsOfURL: fbpicUrl) {
                        self.userImage.image = UIImage(data: data)
                        let imageFile:PFFile = PFFile(data: data)
                        PFUser.currentUser()?["image"] = imageFile
                        PFUser.currentUser()?.save()
                    }
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
