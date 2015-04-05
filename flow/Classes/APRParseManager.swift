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
class APRParseManager: NSObject
{
    //MARK: - Class Functions
    /**
     * sharedManager
     *
     * Returns a singleton instance of ParseManager
     */
    class var sharedManager: APRParseManager
    {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: APRParseManager? = nil
        }
        
        dispatch_once(&Static.onceToken) {
            Static.instance = APRParseManager()
        }
        return Static.instance!
    }
    

    //MARK: - Add Functions
    /**
     * addUser
     *
     * Given an APRUser, saves to Parse cloud.
     */
    func addUser(user: APRUser)
    {
        var tempUser = PFObject(className:"APRUser")
        tempUser["userID"] = user.getUserID()
        tempUser["nickname"] = user.getNickname()
        
        println("user[nick: %@, id: %@]", user.getUserID(), user.getNickname());
        
        tempUser.saveInBackgroundWithBlock {
        (success: Bool, error: NSError!) -> Void in
            if (success)
            {
                var objID = tempUser.objectId
                user.setObjectID(objID)
            }
        }
    }
    
    
    /**
     * addState
     *
     * Given an APRState object, saves to Parse cloud.
     *
     * :param: state - to be added
     */
    func addState(state: APRState)
    {
        var tempState = PFObject(className:"APRState")
        tempState["stateID"] = state.getStateID()
        tempState["name"] = state.getName()
        tempState["color"] = state.getColor()
        tempState["icon"] = state.getIcon()
        
        tempState.saveInBackgroundWithBlock {
        (success: Bool, error: NSError!) -> Void in
            if (success)
            {
                var objID = tempState.objectId
                state.setObjectID(objID)
            }
        }
    }

    /**
     * addState
     *
     * Given an APRState, add it to Parse Cloud
     * and runs the completion code block.
     *
     * :param: state - state to add
     * :param: completion - code block to run on completion
     */
    func addState(state:APRState, completion:((success:Bool)->Void))
    {
        var tempState = PFObject(className:"APRState")
        tempState["stateID"] = state.getStateID()
        tempState["name"] = state.getName()
        tempState["color"] = state.getColor()
        tempState["icon"] = state.getIcon()
        
        tempState.saveInBackgroundWithBlock {
        (success: Bool, error: NSError!) -> Void in
            if (success)
            {
                var objID = tempState.objectId
                state.setObjectID(objID)
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


    //MARK: - Nickname Functions
    /**
     * nicknameForUserIDExists
     *
     * Given an userID, tells completion handler
     * whether the userID already has a corresponding nickname
     *
     * :param: userID - to search nickname using
     * :param: completion - code block to run upon completion
     */
    func nicknameForUserIDExists(userID:NSString, completion:((nickname:NSString?, found:Bool) -> Void)) -> Void
    {
        var query = PFQuery(className: "APRUser");
        query.whereKey("userID", equalTo:userID);
        
        query.getFirstObjectInBackgroundWithBlock {
        (object: PFObject!, error: NSError!) -> Void in
            if (error != nil)
            {
                completion(nickname:nil, found:false);
            }
            else
            {
                completion(nickname:object["nickname"] as? NSString, found:(object != nil) );
            }
        }
    }
    
    
    /**
     * nicknameForUserIDExists
     *
     * Given an nickname, tells completion handler
     * whether the nickname already has a corresponding userID
     *
     * :param: nickname - to search userID using
     * :param: completion - code block to run upon completion
     */
    func userIDForNicknameExists(nickname:NSString, completion:((userID:NSString?, found:Bool) -> Void)) -> Void
    {
        println("hello?")
    
        var query = PFQuery(className: "APRUser");
        query.whereKey("userID", equalTo:nickname);
        
        query.getFirstObjectInBackgroundWithBlock {
            (object: PFObject!, error: NSError!) -> Void in
            if (error != nil)
            {
                completion(userID:nil, found:false);
            }
            else
            {
                completion(userID:object["userID"] as? NSString, found:(object != nil) );
            }
        }
    }
    
    
    /**
     * nicknameForUserID
     *
     * Given an userID and completion handler,
     * tells whether the userID has a
     *
     * :param: userID - to search nickname using
     * :param: completion - code block to run upon completion
     */
    func nicknameForUserID(userID:NSString, completion:((nickname:NSString?)->Void)) -> Void
    {
        var userQuery = PFQuery(className: "APRUser")
        userQuery.whereKey("userID", equalTo:userID)
        
        userQuery.findObjectsInBackgroundWithBlock {
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

    /**
     * userIDForNickname
     *
     * Given a nickname and completion handler,
     * searchs for a user with the nickname
     * and runs the completion code block
     *
     * :param: nickname - to search userID using
     * :param: completion - code block to run upon completion
     */
    func userIDForNickname(nickname:NSString, completion:((userID:NSString?)->Void)) -> Void
    {
        var userQuery = PFQuery(className: "APRUser")
        userQuery.whereKey("nickname", equalTo:nickname)
        
        userQuery.findObjectsInBackgroundWithBlock {
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
}