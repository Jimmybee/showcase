//
//  CoreDataManager.swift
//  Showcase
//
//  Created by James Birtwell on 08/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

//    self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

class CoreDataManager: PersistentDataManager {
    static var shared = CoreDataManager()
    var context: NSManagedObjectContext { return  persistentContainer.viewContext }
    let observer = CoreDataObserver()
    
    init() {
        observer.delegate = self
    }
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Showcase")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func save<T: CoreSave>(models: [T]){
        models.forEach{ $0.createInContext() }
        saveContext()
    }
    
    // MARK: - Core Data Saving support
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
                logD("CoreData context saved")
            } catch {
                error.log()
            }
        }
    }
    
    func load<T: PersistCoreData>(predicate: NSPredicate?) -> [T] {
        do {
            guard let objects = try context.fetch(T.CoreModel.fetchRequest()) as? [T.CoreModel] else {
               throw ClientError.unknownError("TypeCast failed")
            }
            let memoryModels = objects.compactMap{ T($0) }
            logD("\(T.self) loaded by \(self)")
            return memoryModels
        } catch {
            error.log()
        }
        return []
    }
    
    func delete<T: PersistCoreData>(model: T.Type) {
        let fetchRequest = T.CoreModel.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            logD("\(T.self) deleted by \(self)")
        } catch {
            error.log()
        }
    }
}

