//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//  Hien Le

import UIKit
import Parse
import FBSDKCoreKit

class ViewController: UIViewController {
    
    @IBAction func signIn(sender: AnyObject) {
        
        let permissions = ["public_profile", "email"]
        
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, block: {
            
            (user: PFUser?, error: NSError?) -> Void in
            
            if let error = error {
                
                print(error)
                
            } else {
                
                if let user = user {
                    
                    if let interestedInWomen = user["interestedInWomen"] {
                        
                        self.performSegueWithIdentifier("logUserIn", sender: self)
                        
                    } else {
                        
                        self.performSegueWithIdentifier("showSigninScreen", sender: self)
                        
                    }
                }
                
                
            }
            
            
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
       
    }
    
    override func viewDidAppear(animated: Bool) {
        if let username = PFUser.currentUser()?.username {
                self.performSegueWithIdentifier("showSigninScreen", sender: self)
            }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

