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
    associatedtype MemoryModel: PersistRealm
    associatedtype RealmModel: Object
    
    init(_ model: MemoryModel)
    
    static func construct(model: MemoryModel) -> RealmModel
}


protocol RealmSave {
    associatedtype RealmModel: RealmObject
}

extension RealmSave {
    func realmModel() -> RealmModel.RealmModel {
        return RealmModel.construct(model: self as! RealmModel.MemoryModel)
    }
}
