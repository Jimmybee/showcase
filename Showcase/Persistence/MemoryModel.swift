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

protocol RealmObject where Self: Object {
    associatedtype MemoryModel: CanPersist
    associatedtype RealmModel: Object
    
    init(_ model: MemoryModel)
    
    static func construct(model: MemoryModel) -> RealmModel
}



protocol StandardSave {
    associatedtype RealmModel: RealmObject
    associatedtype CoreModel: CoreDataModel
}

extension StandardSave {
    func realmModel() -> RealmModel.RealmModel {
        return RealmModel.construct(model: self as! RealmModel.MemoryModel)
    }
    
    func createInContext() {
        let model = self as! CoreModel.MemoryModel
        let context = CoreDataManager.shared.context
        CoreModel.create(in: context, post: model)
    }
}






protocol CoreDataModel where Self: NSManagedObject  {
    associatedtype MemoryModel: CanPersist
    associatedtype CoreModel: NSManagedObject
    
    static func create(in: NSManagedObjectContext, post: MemoryModel)
}

protocol CoreDataCreate {
    associatedtype MemoryModel: CanPersist
    associatedtype CoreModel: NSManagedObject
    
    
}
