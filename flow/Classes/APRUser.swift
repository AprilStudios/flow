
import Foundation

/**
 * @class APRUser
 * @brief APRUser
 *
 * The APRUser class stores key components about a specific user including:
 * their name, facebookID, nickname. It also includes the user's current
 * state, how long that state has been active, their custom states,
 * the total time they have spent in every state, and the visibility of states
 *
 * Includes accessor/mutator functions to change above data members
 *
 * @author Alex Hong, Kevin Wu
 * @version 0.1
 */
@objc class APRUser: NSObject
{
    private var state: APRState
    private var nickname: String
    private var userID: String
    private var objectID: String
    private var timeSinceChanged: NSDate
    private var stateTimes: Dictionary<APRState,Int32>
    private var userStates:[APRState]
    private var stateVisabilities:Dictionary<APRState, Bool>
    
    override init()
    {
        self.state = APRState()
        self.nickname=String()
        self.userID=String()
        self.objectID=String()
        self.timeSinceChanged = NSDate()
        self.stateTimes = Dictionary<APRState,Int32>()
        self.userStates = [APRState]()
        self.stateVisabilities = Dictionary<APRState, Bool>()
        
        super.init()
    }
    
    init(n:String, u:String)
    {
        self.state = APRState()
        self.nickname=n
        self.userID=u
        self.objectID=String()
        self.timeSinceChanged = NSDate()
        self.stateTimes = Dictionary<APRState,Int32>()
        self.userStates = [APRState]()
        self.stateVisabilities = Dictionary<APRState, Bool>()
        super.init()
    }
    
    //Accessor functions
    func getState()-> APRState {
        return state
    }
    func getNickname()-> String{
        return nickname
    }
    func getUserID()-> String {
        return userID
    }
    func getObjectID()-> String {
        return objectID
    }
    func getTimeSinceChanged()-> NSDate {
        return timeSinceChanged
    }
    func getStateTimes()-> Dictionary<APRState,Int32> {
        return stateTimes
    }
    func getUserStates()->[APRState] {
        return userStates
    }
    func getStateVisabilities()-> Dictionary<APRState, Bool> {
        return stateVisabilities
    }
    
    //Mutator functions
    func setState(s:APRState)-> Void {
        state = s
    }
    func setNickname(n:String)-> Void {
        nickname = n
    }
    func setObjectID(o:String)-> Void{
        objectID = o
    }
    /**
    * @method <setTimeSinceChanged>
    *
    * @note Designed to be used alongside setState, when a state is about to change.
    * Although written as mutator function with arguments,
    * it typically will reset the timeSinceChanged to the current time
    * which should be done in APRParseManager
    *
    *     *
    * @param <NSDate> - date
    *
    * @return void
    */
    func setTimeSinceChanged(date:NSDate)-> Void {
        timeSinceChanged = date
    }
    
    /**
    * @method <addToStateTimes>
    *
    * @note Designed to be used alongside setState when a state is about to change.
    * The state's time in action is recorded and added to the dictionary stateTimes
    *
    * @param <APRState> - userState
    * @param <Int32> - 32-bit integer value
    *
    * @return void
    */
    func addToStateTimes(s:APRState, i:Int32)-> Void {
        if(stateTimes[s]==nil) {
            stateTimes[s]=i
        }
        else {
            stateTimes[s]=stateTimes[s]!+i
        }
    }
    func addUserStates(s:APRState)-> Void {
        for state in userStates {
            if state.getObjectID() == s.getObjectID()
            {
                return
            }
        }
        userStates.append(s)
    }
    func setStateVisabilities(s: APRState, b: Bool)-> Void {
        stateVisabilities[s]=b
    }
}
