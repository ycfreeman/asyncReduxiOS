import Foundation
import JavaScriptCore
import RxSwift
// copy code from http://nshipster.com/javascriptcore/

// Custom protocol must be declared with `@objc`
@objc protocol JSItemJSExports : JSExport {
    var id: NSNumber { get set }
    var str: String { get set }
    var int: NSNumber { get set }
    // we can export internal values to JS like this
    
    static func createWithId(id: NSNumber, str: String, int: NSNumber) -> JSItem
    
    // static emit function (shouldn't be here)
    static func emitSection(section: String, items: [JSItem])
}

// Custom class must inherit from `NSObject`
@objc public class JSItem : NSObject, JSItemJSExports {
    // properties must be declared as `dynamic`
    dynamic var id: NSNumber
    dynamic var str: String {
        didSet {
            strObservable.value = str
        }
    }
    dynamic var int: NSNumber {
        didSet {
            intObservable.value = int.integerValue
        }
    }
    
    private var strObservable: Variable<String>
    private var intObservable: Variable<Int>
    
    
    var intOutlet: Observable<String> {
        return intObservable.asObservable().map({ number -> String in
            return "\(number)"
        })
    }
    
    var strOutlet: Observable<String> {
        return strObservable.asObservable()
    }
    
    init(id: NSNumber, str: String, int: NSNumber) {
        self.id = id
        self.str = str
        self.int = int
        self.intObservable = Variable(self.int.integerValue)
        self.strObservable = Variable(self.str)
    }
    
    public class func createWithId(id: NSNumber, str: String, int: NSNumber) -> JSItem {
        return JSItem(id: id, str: str, int: int)
    }
    
    public class func emitSection(section: String, items: [JSItem]) {
        // switch from Web Tread to Global Thread
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            ItemService.sharedInstance.setSectionItems(section, items: items)
        }
    }
   
}
