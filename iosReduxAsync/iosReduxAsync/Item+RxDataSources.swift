//
//  Item+RxDataSource.swift
//  iosReduxAsync
//
//  Created by Freeman on 25/7/16.
//  Copyright © 2016 Freeman. All rights reserved.
//

import Foundation
import RxDataSources


extension JSItem: IdentifiableType {
    
    public typealias Identity = Int
    public var identity: Int {
        return hashValue
    }
    
    public override func isEqual(object: AnyObject?) -> Bool {
        guard let other = object as? JSItem else{
            return false
        }
        return other.str == self.str &&
            other.int.integerValue == self.int.integerValue
    }
    
}


func == (lhs: JSItem, rhs: JSItem) -> Bool {
    return lhs.isEqual(rhs)
}


struct JSItemSection: AnimatableSectionModelType {
    typealias Item = JSItem
    typealias Identity = String
    
    var header: String
    var items: [JSItem]
    
    init(header: String, items: [JSItem]){
        self.header = header
        self.items = items
    }
    
    init(original: JSItemSection, items: [JSItem]) {
        self = original
        self.items = items
    }
    
    var identity: String {
        return header
    }
}
