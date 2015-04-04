//
//  APRParseManager.swift
//  flow
//
//  Created by Alex Hong on 4/4/15.
//  Copyright (c) 2015 AprilStudios. All rights reserved.
//

import Foundation

class APRParseManager: NSObject {
    override init() {
        super.init()
        println("SwiftClass init")
    }
    func addUser(u: APRUser) {
        var tempUser = PFObject(className:"APRUser")
        tempUser["userID"] = u.getUserID()
        tempUser["facebookID"] = u.getFacebookID()
        tempUser["nickname"] = u.getNickname()
        tempUser.saveInBackgroundWithBlock {
            (success: Bool, error: NSError!) -> Void in
            if (success) {
                var objID = tempUser.objectId
                u.setObjectID(objID)
            }
        }
    }
    
    func addState(s: APRState) {
        var tempState = PFObject(className:"APRState")
        tempState["stateID"] = s.getStateID()
        tempState["name"] = s.getName()
        tempState["color"] = s.getColor()
        tempState["icon"] = s.getIcon()
        tempState.saveInBackgroundWithBlock {
            (success: Bool, error: NSError!) -> Void in
            if (success) {
                var objID = tempState.objectId
                s.setObjectID(objID)
            }
        }
    }
    /*
    Adds state s to a part of user u's states variable (An NSArray) and the amount of time they were in such a state
    */
    func addStateForUser(u: APRUser, s: APRState) {
        var userQuery = PFQuery(className:"APRUser");
        var stateQuery = PFQuery(className:"APRState")
        userQuery.getObjectInBackgroundWithId(u.getObjectID()) {
            (tempUser: PFObject!, error: NSError!) -> Void in
            if error != nil {
                println(error)
            } else {
                //User Found
                stateQuery.getObjectInBackgroundWithId(s.getObjectID()) {
                    (tempState: PFObject!, error: NSError!) -> Void in
                    if error != nil {
                        self.addCustomStateForUser(u, s: s)
                    } else {
                        //State found
                        var stateIDs = [String]()
                        stateIDs = (tempUser["stateIDs"] as? NSArray) as Array!
                        stateIDs.append(s.getObjectID())
                        tempUser["stateIDs"] = stateIDs
                    }
                }
            }
        }
    }
    
    func addCustomStateForUser(u: APRUser, s: APRState) {
        var tempState = PFObject(className:"APRState")
        tempState["stateID"] = s.getStateID()
        tempState["name"] = s.getName()
        tempState["color"] = s.getColor()
        tempState["icon"] = s.getIcon()
        tempState.saveInBackgroundWithBlock {
            (success: Bool, error: NSError!) -> Void in
            if (success) {
                var objID = tempState.objectId
                s.setObjectID(objID)
                self.addStateForUser(u, s: s)
            }
        }
    }
    
    
    
    
    func test() -> Void {
        
        //updating and not updating
        /*var gameScore = PFObject(className: "GameScore")
        gameScore.setObject(1337, forKey: "score")
        gameScore.setObject("Sean Plott", forKey: "playerName")
        gameScore.saveInBackgroundWithBlock {
            (success: Bool!, error: NSError!) -> Void in
            if (success != nil) {
                println("Object created with id: \(gameScore.objectId)")
            } else {
                println("%@", error)
            }
        }
        var query = PFQuery(className:"GameScore")
        query.getObjectInBackgroundWithId("qZzAaTMckw") {
            (gameScore: PFObject!, error: NSError!)-> Void in
            if error != nil {
                println(error)
            } else {
                gameScore["score"] = 200
                gameScore.saveInBackground()
            }
        }*/
    }
}