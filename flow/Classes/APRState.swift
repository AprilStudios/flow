
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
    //MARK: - Private Instance Vars
    private var name: String
    private var color: String
    private var icon: String
    //private var stateID: Int
    private var objectID: String


    //MARK: - Init Funcs
    /**
     * init
     *
     * Initializes an APRUser with blank fields.
     */
    override init()
    {
        self.name = String()
        self.color = String()
        self.icon = String()
        //self.stateID = Int()
        self.objectID = String()
        super.init()
    }
    
    /**
     * init
     *
     * Creates a APRUser with the given params.
     */
    init(name:String, color:String, icon:String, /*stateID:Int,*/ objectID:String)
    {
        self.name = name
        self.color = color
        self.icon = icon
        //self.stateID = stateID
        self.objectID = objectID
        
        super.init()
    }
    
    
    //MARK: - Accessors
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
    
    /*func getStateID() -> Int
    {
        return stateID
    }*/
    
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
