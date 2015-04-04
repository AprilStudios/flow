
import Foundation

/**
* @class APRState
* @brief APRState
*
*
* @author Kevin Wu, Alex Hong
* @version 0.1
*/
@objc class APRState: NSObject
{
    private var name: String
    private var color: String
    private var icon: String
    private var stateID: Int
    private var objectID: String

    /**
     * @method init
     *
     *
     */
    override init()
    {
        self.name = String()
        self.color = String()
        self.icon = String()
        self.stateID = Int()
        self.objectID = String()
        super.init()
    }
    
    /**
     *
     *
     *
     */
    init(n:String, c:String, i:String, s:Int, o:String)
    {
        self.name=n
        self.color=c
        self.icon=i
        self.stateID=s
        self.objectID=o
        super.init()
    }
    
    
    /* Accessors */
    func getName() -> String
    {
        return name
    }
    
    func getColor() -> String
    {
        return color
    }

    func getIcon() -> String
    {
        return icon
    }
    
    func getStateID() -> Int
    {
        return stateID
    }
    
    func getObjectID() -> String
    {
        return objectID
    }
    
    func setName(n:String) -> Void
    {
        name = n
    }
    
    func setColor(c:String) -> Void
    {
        color = c
    }
    
    func setIcon(i:String) -> Void
    {
        icon = i
    }
    
    func setObjectID(o:String)-> Void
    {
        objectID = o
    }
    
}
