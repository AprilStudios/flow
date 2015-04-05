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
    
    func addUserList() {
        var tempClass = PFObject(className: "Sample");
        tempClass["tempArray"]=["1","2","3"]
        tempClass.saveInBackground()
    }
    
    //doesn't guard against User already being in database
    func addUser(u: APRUser) {
        var tempUser = PFObject(className:"APRUser")
        tempUser["userID"] = u.getUserID()
        tempUser["nickname"] = u.getNickname()
        var array = [String]()
        tempUser["userStates"] = array
        /*(tempUser["userStates"] as [String]).append("what")*/
        
        tempUser.saveInBackgroundWithBlock {
            (success: Bool, error: NSError!) -> Void in
            if (success) {
                var objID = tempUser.objectId
                u.setObjectID(objID)
            }
        }
    }
    
    //doesn't guard against User already being in database
    func addUser(u: APRUser, completion:((finishedUser:NSNumber)->Void))-> Void {
        var tempUser = PFObject(className:"APRUser")
        tempUser["userID"] = u.getUserID()
        tempUser["nickname"] = u.getNickname()
        var array = ["1", "2", "3"]
        array.append("WHAT")
        tempUser["userStates"] = array
        /*(tempUser["userStates"] as [String]).append("what")*/
        
        tempUser.saveInBackgroundWithBlock {
            (success: Bool, error: NSError!) -> Void in
            if (success) {
                var objID = tempUser.objectId
                println("WTF:::: ")
                println(objID)
                u.setObjectID(objID)
            } else {
                println("ERROR???")
            }
            completion(finishedUser: 1)
        }
    }
    
    func addState(s: APRState) {
        var tempState = PFObject(className:"APRState")
        tempState["stateID"] = s.getStateID()
        tempState["name"] = s.getName()
        tempState["color"] = s.getColor()
        tempState["icon"] = s.getIcon()
        println("what")
        tempState.saveInBackgroundWithBlock {
            (success: Bool, error: NSError!) -> Void in
            if (success) {
                var objID = tempState.objectId
                s.setObjectID(objID)
            }
        }
        return
    }

    func addState(s: APRState, completion:((finishedState:NSNumber)->Void))->Void {
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
                completion(finishedState: 1)
            }
        }
        return
    }
    
    /*
    Adds state s to a part of user u's states variable (An NSArray) and the amount of time they were in such a state
    */
    func addStateForUser(u: APRUser, s: APRState) {
        var tempUserArray = u.getUserStates()
        var tempUser = PFQuery(className:"APRUser")
        tempUser.getObjectInBackgroundWithId(u.getObjectID()) {
            (updateUser: PFObject!, error: NSError!) -> Void in
            if error != nil
            {
                println(error)
            }
            else
            {
                for tempState in tempUserArray
                {
                    if tempState.getObjectID()==s.getObjectID()
                    {
                        return
                    }
                }
                var tempStates = updateUser["userStates"] as [String]
                tempStates.append(s.getObjectID())
                updateUser["userStates"] = tempStates
                updateUser.saveInBackground()
            }
        }
    }
        
        
        
        /*var userQuery = PFQuery(className:"APRUser");
        var stateQuery = PFQuery(className:"APRState")
        userQuery.getObjectInBackgroundWithId(u.getObjectID()) {
            (tempUser: PFObject!, error: NSError!) -> Void in
            if error != nil
            {
                println(error)
            }
            else
            {
                self.stateExists(s, completion: {(success:Bool) in
                    if (success) {
                        self
                    } else {
                        
                    }
                })
                //User Found
                /*stateQuery.getObjectInBackgroundWithId(s.getObjectID()) {
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
                    tempUser.saveInBackground()*/
                }
            }
        }*/
    }
    
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
    
    //
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
        return
    }

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
    }
