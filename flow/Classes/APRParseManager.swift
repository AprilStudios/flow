import Foundation

/**
* @class APRParseManager
* @brief APRParseManager
*
* This class handles direct interaction with Parse, including saving data in the form of PFObjects,
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
    
    /**
     * addUser
     *
     * Adds the given APRUser to ParseCloud
     *
     * :note: doesn't guard against User already being in database
     *
     * :param: user - to save to Parse
     */
    func addUser(user: APRUser)
    {
        var tempUser = PFObject(className:"APRUser")
        tempUser["userID"] = user.getUserID()
        tempUser["nickname"] = user.getNickname()
        
        var array = [String]()
        tempUser["userStates"] = array
        /*(tempUser["userStates"] as [String]).append("what")*/
        
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
     * addUser
     *
     * Adds the given APRUser to ParseCloud,
     * and runs completion code block.
     *
     * :param: user - to save to Parse
     * :param: completion - code block to run upon completion
     */
    func addUser(user:APRUser, completion:((finished:Bool) -> Void)) -> Void
    {
        var tempUser = PFObject(className:"APRUser")
        tempUser["userID"] = user.getUserID()
        tempUser["nickname"] = user.getNickname()
        
        var array = ["1", "2", "3"]
        array.append("WHAT")
        tempUser["userStates"] = array
        /*(tempUser["userStates"] as [String]).append("what")*/
        
        tempUser.saveInBackgroundWithBlock{
        (success: Bool, error: NSError!) -> Void in
        
            if (success)
            {
                var objID = tempUser.objectId
                println("WTF:::: ")
                println(objID)
                user.setObjectID(objID)
            }
            else
            {
                println("ERROR???")
            }
            completion(finished:true)
        }
    }
    
    
    /**
     * addState
     *
     * Given an APRState object, saves to Parse cloud.
     *
     * :param: state - to be added
     */
    func addState(s: APRState)
    {
        var tempState = PFObject(className:"APRState")
        tempState["stateID"] = s.getStateID()
        tempState["name"] = s.getName()
        tempState["color"] = s.getColor()
        tempState["icon"] = s.getIcon()
        println("what")
        tempState.saveInBackgroundWithBlock {
        (success: Bool, error: NSError!) -> Void in
            if (success)
            {
                var objID = tempState.objectId
                s.setObjectID(objID)
            }
        }
        return
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
    func addState(s: APRState, completion:((finished:Bool) -> Void)) -> Void
    {
        var tempState = PFObject(className:"APRState")
        tempState["stateID"] = s.getStateID()
        tempState["name"] = s.getName()
        tempState["color"] = s.getColor()
        tempState["icon"] = s.getIcon()
        
        tempState.saveInBackgroundWithBlock {
        (success: Bool, error: NSError!) -> Void in
            if (success)
            {
                var objID = tempState.objectId
                s.setObjectID(objID)
                completion(finished: true)
            }
        }
        return
    }
    
    /*
    Adds state s to a part of user u's states variable (An NSArray) and the amount of time they were in such a state
    */
    func addStateForUser(user:APRUser, state:APRState)
    {
        var tempUserArray = user.getUserStates()
        var tempUser = PFQuery(className:"APRUser")
        
        tempUser.getObjectInBackgroundWithId(user.getObjectID()) {
        (updateUser: PFObject!, error: NSError!) -> Void in
        
            if error != nil
            {
                println(error)
            }
            else
            {
                for tempState in tempUserArray
                {
                    if tempState.getObjectID() == state.getObjectID()
                    {
                        return
                    }
                }
                var tempStates = updateUser["userStates"] as [String]
                tempStates.append(state.getObjectID())
                updateUser["userStates"] = tempStates
                updateUser.saveInBackground()
            }
        }
    }
    
    /**
     * stateExists
     *
     * Checks Parse if state exists.
     * 
     * :param: state - to check if duplicate
     * :param: completion - code block to run after completion
     */
    func stateExists(state:APRState, completion:((doesStateExists:Bool)->Void)) -> Void
    {
        var stateQuery = PFQuery(className:"APRState")
        stateQuery.getObjectInBackgroundWithId(state.getObjectID()) {
        (tempState: PFObject!, error: NSError!) -> Void in
            if error != nil
            {
                completion(doesStateExists:true)
            }
            else
            {
                completion(doesStateExists:false)
            }
        }
    }


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
                else
                {
                    println("Error")
                }
            }
        }
    }
}


