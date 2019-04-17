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
    associatedtype MemoryModel: CanPersist
    associatedtype CoreModel: NSManagedObject
    
    static func create(in: NSManagedObjectContext, post: Post)
    
}
