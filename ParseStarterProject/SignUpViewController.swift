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
        PFUser.currentUser()?["interestedInWomen"] = interestedInWomen.on
        PFUser.currentUser()?.save()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlArray = ["http://www.thezerosbeforetheone.com/wordpress/wp-content/uploads/2011/07/smurfette-300x225.gif",
            "http://www.polyvore.com/cgi/img-thing?.out=jpg&size=l&tid=44643840",
            "http://www.polyvore.com/cgi/img-thing?.out=jpg&size=l&tid=62956603",
            "http://static.comicvine.com/uploads/square_small/0/2617/103863-63963-torongo-leela.JPG",
            "http://www.theunknownpen.com/wp-content/uploads/2013/03/Velma.jpg",
            "http://assets.makers.com/styles/mobile_gallery/s3/betty-boop-cartoon-576km071213_0.jpg?itok=9qNg6GUd",
            "http://magicdisneyheros.altervista.org/images/midl/97.jpg"]
        
        var counter = 1
        for url in urlArray {
            let nsUrl = NSURL(string: url)!
            if let data = NSData(contentsOfURL: nsUrl) {
                self.userImage.image = UIImage(data: data)
                let imageFile:PFFile = PFFile(data: data)
                var user:PFUser = PFUser()
                
                var username = "user\(counter)"
                user.username = username
                user.password = "pass"
                user["image"] = imageFile
                user["interestedInWomen"] = false
                user["gender"] = "female"
                
                counter++
                user.signUp()
            }
        }
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, gender, email"])
        graphRequest.startWithCompletionHandler ({ (connection, result, error) -> Void in
            if error != nil {
                print(error)
            } else if let result = result {
                //print(result)
                PFUser.currentUser()?["gender"] = result["gender"]
                PFUser.currentUser()?["name"] = result["name"]
                PFUser.currentUser()?["email"] = result["email"]
                
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
