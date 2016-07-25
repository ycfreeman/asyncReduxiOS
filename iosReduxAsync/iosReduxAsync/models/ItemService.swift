import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class ItemService {
    static let sharedInstance = ItemService()
    
    private var sections = Variable<[JSItemSection]>([])
    
    private init() {}
    
    func setSectionItems(section: String, items: [JSItem]) {
        guard let existingIndex: Int = sections.value.indexOf({ (itemSection) -> Bool in
        return itemSection.header == section
        }) else {
            // add new section
            sections.value.append(JSItemSection(header: section, items: items))
            return
        }
        sections.value[existingIndex].items = items
    }
    
    var sectionsObservable: Observable<[JSItemSection]> {
        return sections.asObservable()
    }
}