//
//  CoreDataModel.swift
//  Showcase
//
//  Created by James Birtwell on 16/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataModel where Self: NSManagedObject  {
    associatedtype MemoryModel: PersistCoreData
    associatedtype CoreModel: NSManagedObject
    
    static func create(in: NSManagedObjectContext, post: MemoryModel)
}

protocol CoreSave {
    associatedtype CoreModel: CoreDataModel
}
extension CoreSave {
    func createInContext() {
        let model = self as! CoreModel.MemoryModel
        let context = CoreDataManager.shared.context
        CoreModel.create(in: context, post: model)
    }
}
