
import Foundation

/**
 * @class APRUser
 * @brief APRUser
 *
 * 
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
    private var customStates:[APRState]
    private var stateVisabilities:Dictionary<APRState, Bool>
    
    override init()
    {
        self.state = APRState()
        self.nickname=String()
        self.userID=String()
        self.objectID=String()
        self.timeSinceChanged = NSDate()
        self.stateTimes = Dictionary<APRState,Int32>()
        self.customStates = [APRState]()
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
        self.customStates = [APRState]()
        self.stateVisabilities = Dictionary<APRState, Bool>()
        super.init()
    }
    
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
    func getCustomStates()->[APRState] {
        return customStates
    }
    func getStateVisabilities()-> Dictionary<APRState, Bool> {
        return stateVisabilities
    }
    func setState(s:APRState)-> Void {
        state = s
    }
    func setNickname(n:String)-> Void {
        nickname = n
    }
    func setObjectID(o:String)-> Void{
        objectID = o
    }
    func setTimeSinceChanged(date:NSDate)-> Void {
        timeSinceChanged = date
    }
    func addToStateTimes(s:APRState, i:Int32)-> Void {
        if(stateTimes[s]==nil) {
            stateTimes[s]=i
        }
        else {
            stateTimes[s]=stateTimes[s]!+i
        }
    }
    func addCustomState(s:APRState)-> Void {
        customStates.append(s)
    }
    func setStateVisabilities(s: APRState, b: Bool)-> Void {
        stateVisabilities[s]=b
    }
}
