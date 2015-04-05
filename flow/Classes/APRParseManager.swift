import Foundation

/**
* @class APRParseManager
* @brief APRParseManager
*
* This class handles direct interaction with Parse, including saving data in the form of PFObjects,
* 
*
*
*
* @author Alex Hong, Kevin Wu
* @version 0.1
*/


class APRParseManager: NSObject {
    override init() {
        super.init()
        println("SwiftClass init")
    }
    private var createdUserStatesID = false;
    func addUser(u: APRUser) {
        var tempUser = PFObject(className:"APRUser")
        tempUser["userID"] = u.getUserID()
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

    func addState(s: APRState, completion:((success:Bool)->Void)) {
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
        completion(success: true)
    }
    
    /*
    Adds state s to a part of user u's states variable (An NSArray) and the amount of time they were in such a state
    */
    /*func addStateForUser(u: APRUser, s: APRState) {
        var userQuery = PFQuery(className:"APRUser");
        var stateQuery = PFQuery(className:"APRState")
        userQuery.getObjectInBackgroundWithId(u.getObjectID()) {
            (tempUser: PFObject!, error: NSError!) -> Void in
            if error != nil
            {
                println(error)
            }
            else
            {
                //User Found
                stateQuery.getObjectInBackgroundWithId(s.getObjectID()) {
                    (tempState: PFObject!, error: NSError!) -> Void in
                    if error != nil
                    {
                        self.addState(s, completion: {(Bool) in
                            //State found
                            if (self.createdUserStatesID) {
                                var userStatesID = [String]()
                                userStatesID = (tempUser["userStatesID"] as? NSArray) as Array!
                                userStatesID.append(s.getObjectID())
                                tempUser["userStatesID"] = userStatesID
                            } else {
                                var userStatesID = ["2", "3"]
                                tempUser["userStatesID"] = userStatesID
                                self.createdUserStatesID = true
                            }
                        })
                    }
                    //State found
                    if (self.createdUserStatesID) {
                        var userStatesID = [String]()
                        userStatesID = (tempUser["userStatesID"] as? NSArray) as Array!
                        userStatesID.append(s.getObjectID())
                        tempUser["userStatesID"] = userStatesID
                    } else {
                        var userStatesID = [s.getObjectID()]
                        tempUser["userStatesID"] = userStatesID
                        self.createdUserStatesID = true
                    }
                    tempState.saveInBackground()
                    tempUser.saveInBackground()
                }
            }
        }
    }*/
    
    /*func makeUser(objectId:String)-> APRUser {
        var userQuery = PFQuery(className: "APRUser")
        userQuery.getObjectInBackgroundWithId(u) {
            (userObject: PFObject!, error:NSError!)-> Void in
            if error == nil && userObject != nil {
                println(userObject)
            } else {
                println(error)
            }
        }
    }*/
    /*func makeState(objectId:String)-> APRState {

    }*/

    func nicknameForUserID(u:NSString, completion:((nickname:NSString?)->Void)) -> Void
    {
        var userQuery = PFQuery(className: "APRUser")
        userQuery.whereKey("userID", equalTo:u)
        userQuery.findObjectsInBackgroundWithBlock
        {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil
            {
                println("Successfully retrieved")
                if let objects = objects as? [PFObject]
                {
                    if objects.count==1
                    {
                        let n = objects[0]["nickname"] as NSString
                        completion(nickname: n)
                        return
                    }
                    else
                    {
                        completion(nickname: nil)
                        return
                    }
                }
            }
            else
            {
                println("Error")
            }
        }
    }

    func userIDForNickname(nickname:NSString, completion:((userID:NSString?)->Void)) -> Void
    {
        var userQuery = PFQuery(className: "APRUser")
        userQuery.whereKey("nickname", equalTo:nickname)
        userQuery.findObjectsInBackgroundWithBlock
            {
                (objects: [AnyObject]!, error: NSError!) -> Void in
                if error == nil
                {
                    println("Successfully retrieved")
                    if let objects = objects as? [PFObject]
                    {
                        if objects.count==1
                        {
                            let n = objects[0]["userID"] as NSString
                            completion(userID: n)
                            return
                        }
                        else
                        {
                            completion(userID: nil)
                            return
                        }
                    }
                }
                else
                {
                    println("Error")
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