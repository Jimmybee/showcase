//
//  RealmObject.swift
//  Showcase
//
//  Created by James Birtwell on 17/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmObject where Self: Object {
    associatedtype MemoryModel: RealmLoadable
    associatedtype RealmModel: Object
    
    init(_ model: MemoryModel)
}

protocol RealmObjectWithId where Self: RealmObject {    
    var id: Int { get }
}


