//
//  APRMainViewController.swift
//  flow
//
//  Created by Darvish Kamalia on 4/4/15.
//  Copyright (c) 2015 AprilStudios. All rights reserved.
//

import UIKit

struct state {
    
    var name: String
    var circleColor: UIColor
    
    
}

class APRMainViewController: UIViewController {
    
    var states: [state] = []
    var firstName:String!
    var secondName:String!
    var email:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        states.append(state(name: "Working", circleColor: UIColor.blueColor()))
        states.append(state(name: "Eating", circleColor: UIColor.yellowColor()))
        states.append(state(name: "Lifting", circleColor: UIColor.cyanColor()))
        
        
        // Do any additional setup after loading the view.
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
func loginViewFetchedUserInfo(loginView: FBLoginView!, user : FBGraphUser){
    (connection, user, error)-> Void in
    self.email== user.objectForKey("email") as String!
    
    
    
}
