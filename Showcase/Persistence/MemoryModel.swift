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


typealias CanPersist = PersistRealm & PersistCoreData
typealias StandardSave = RealmSave & CoreSave

protocol PersistRealm {
    associatedtype RealmModel: Object
    init?(_ object: RealmModel)
}

protocol PersistCoreData {
    associatedtype CoreModel: NSManagedObject
    init?(_ coreModel: CoreModel)
}


