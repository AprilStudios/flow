
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
    private var icon: String
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
        self.icon = String()
        self.objectID = String()
        super.init()
    }
    
    /**
     * init
     *
     * Creates a APRUser with the given params.
     */
    init(name:String, icon:String, objectID:String)
    {
        self.name = name
        self.icon = icon
        self.objectID = objectID
        
        super.init()
    }
    
    
    //MARK: - Accessors
    func getName() -> String
    {
        return name
    }
    
    func getIcon() -> String
    {
        return icon
    }
    func getObjectID() -> String
    {
        return objectID
    }
    
    func setName(n:String) -> Void
    {
        name = n
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
