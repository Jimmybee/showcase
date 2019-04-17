//
//  MemoryModel.swift
//  Showcase
//
//  Created by James Birtwell on 16/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import RealmSwift
import CoreData

protocol CanPersist {
    associatedtype RealmModel: Object
    associatedtype CoreModel: NSManagedObject
    
    init?(_ object: RealmModel)
    init?(_ coreModel: CoreModel)
}

protocol StandardSave {
    associatedtype RealmModel: RealmObject

}

extension StandardSave {
    func realmModel() -> RealmModel.RealmModel {
        return RealmModel.construct(model: self as! RealmModel.MemoryModel)
    }
}


protocol RealmObject where Self: Object {
    associatedtype MemoryModel: CanPersist
    associatedtype RealmModel: Object
    
    init(_ model: MemoryModel)
    
    static func construct(model: MemoryModel) -> RealmModel
}



