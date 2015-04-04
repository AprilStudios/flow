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