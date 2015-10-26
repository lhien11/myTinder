//
//  SwipingViewController.swift
//  ParseStarterProject
//
//  Created by Hien Le on 10/25/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class SwipingViewController: UIViewController {

    @IBOutlet var userImage: UIImageView!
    @IBOutlet var infoLabel: UILabel!
    
    var displayedUserId = ""
    
    func wasDragged(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translationInView(self.view)
        let label = gesture.view!
        
        label.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2 + translation.y)
        
        let xFromCenter = label.center.x - self.view.bounds.width / 2
        
        let scale = min(100 / abs(xFromCenter), 1)
        
        
        var rotation = CGAffineTransformMakeRotation(xFromCenter / 200)
        
        var stretch = CGAffineTransformScale(rotation, scale, scale)
        
        label.transform = stretch
        
        
        if gesture.state == UIGestureRecognizerState.Ended {
            
            var acceptedOrRejected = ""
            
            if label.center.x < 100 {
                
                //print("Not chosen " + displayedUserId)
                acceptedOrRejected = "rejected"
                
            } else if label.center.x > self.view.bounds.width - 100 {
                
                print("Chosen")
                acceptedOrRejected = "accepted"
                
            }
            
            if acceptedOrRejected != "" {
                
                PFUser.currentUser()?.addUniqueObjectsFromArray([displayedUserId], forKey:acceptedOrRejected)
                
                PFUser.currentUser()?.save()
                
            }
            
            rotation = CGAffineTransformMakeRotation(0)
            
            stretch = CGAffineTransformScale(rotation, 1, 1)
            
            label.transform = stretch
            
            label.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
            
            updateImage()
            
        }
        
        
        
    }
    
    func updateImage() {
        
        var query = PFUser.query()!
        
        if let latitude = PFUser.currentUser()?["location"]!.latitude {
            
            if let longtitude = PFUser.currentUser()?["location"]!.longitude{
                print(latitude)
                print(longtitude)
                
                query.whereKey("location", withinGeoBoxFromSouthwest: PFGeoPoint(latitude: latitude-1 , longitude: longtitude-1), toNortheast: PFGeoPoint(latitude: latitude+1, longitude: longtitude+1))
            }
        }
        


        var interestedIn = "male"
        
        
        PFUser.currentUser()?["interestedInWomen"] = true
        
        if PFUser.currentUser()!["interestedInWomen"]! as! Bool == true {
            
            interestedIn = "female"
            
        }
        var isFemale = true
        
        PFUser.currentUser()?["gender"] = "male"

        if PFUser.currentUser()?["gender"]! as! String == "male" {
            isFemale = false
        }
        
        query.whereKey("gender", equalTo: interestedIn)
        query.whereKey("interestedInWomen", equalTo: isFemale)
        //query.whereKey("objectId", notContainedIn: PFUser.currentUser()!["accepted"] as! Array)
        //query.whereKey("objectId", notContainedIn: PFUser.currentUser()!["rejected"] as! Array)

        
        var ignoredUsers = [""]
        
        if let acceptedUsers = PFUser.currentUser()?["accepted"] {
            ignoredUsers += acceptedUsers as! Array
        }
        
        if let rejectedUsers = PFUser.currentUser()?["rejected"] {
            ignoredUsers += rejectedUsers as! Array
        }
        
        query.whereKey("objectId", notContainedIn: ignoredUsers)
        //query.whereKey("location", withinGeoBoxFromSouthwest: PFGeoPoint(latitude: 0, longitude: 0), toNortheast: PFGeoPoint(latitude: 5, longitude: 5))
        

        
        query.limit = 1
        
    

        

        
        query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            }
            else if let objects = objects as? [PFObject] {
                for object in objects {
                    //print(object)
                    self.displayedUserId = object.objectId!
                    let imageFile = object["image"] as! PFFile
                    
                    imageFile.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                        if error != nil {
                            print(error)
                        } else {
                            if let data = imageData {
                                self.userImage.image = UIImage(data: data)
                                
                            }
                        }
                    })
                }
            }
        })

        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "logOut" {
            PFUser.logOut()
        }
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        userImage.addGestureRecognizer(gesture)
        userImage.userInteractionEnabled = true
        
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            if let geoPoint = geoPoint {
                PFUser.currentUser()?["location"] = geoPoint
                PFUser.currentUser()?.save()
            }
        }
        updateImage()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
