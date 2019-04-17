//
//  CDCreatable.swift
//  Showcase
//
//  Created by James Birtwell on 16/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import CoreData

//https://stoeffn.de/posts/modern-core-data-in-swift/

/// Something that can be created in a core data context, usually an `NSManagedObject`.
public protocol CDCreatable {
    /// Creates this object in the context given.
    ///
    /// - Parameter context: Managed object context.
    /// - Remarks: Default constructor generated by `NSManagedObject`.
    /// - Warning: When creating objects, use `init(createIn:)` instead as it may contain additional initilization logic.
    init(context: NSManagedObjectContext)
    
    /// Creates this object in the context given.
    ///
    /// - Parameter context: Managed object context.
    init(createIn context: NSManagedObjectContext)
}

// MARK: - Default Implementation
extension CDCreatable {
    public init(createIn context: NSManagedObjectContext) {
        self.init(context: context)
    }
}

// MARK: - Utilities
extension CDCreatable where Self: NSManagedObject {
    /// Specifies that this object should be removed from its persistent store when changes are committed. When changes are
    /// committed, the object will be removed from the uniquing tables. If object has not yet been saved to a persistent store,
    /// it is simply removed from `context`.
    ///
    /// - Parameter context: Managed object context.
    func delete(in context: NSManagedObjectContext) {
        context.delete(self)
    }
}

public extension NSFetchRequestResult where Self: NSManagedObject {
    func `in`(_ context: NSManagedObjectContext) -> Self {
        guard let object = context.object(with: objectID) as? Self else {
            fatalError("Cannot find object '\(self)' in context '\(context)'.")
        }
        return object
    }
}

public extension NSFetchRequestResult {
    /// Returns a fetch request for this object, using the parameters given as its properties.
    static func fetchRequest(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor] = [],
                             limit: Int? = nil, offset: Int? = nil, batchSize: Int? = nil,
                             relationshipKeyPathsForPrefetching: [String] = []) -> NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: String(describing: Self.self))
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        request.fetchLimit = limit ?? request.fetchLimit
        request.fetchOffset = offset ?? request.fetchOffset
        request.fetchBatchSize = batchSize ?? request.fetchBatchSize
        request.relationshipKeyPathsForPrefetching = relationshipKeyPathsForPrefetching
        return request
    }
    
    /// Returns an array of all objects of that type in a given context sorted by `sortDescriptors`.
    static func fetch(in context: NSManagedObjectContext, sortDescriptors: [NSSortDescriptor] = []) throws -> [Self] {
        return try context.fetch(fetchRequest(sortDescriptors: sortDescriptors))
    }
    
    
    static func deleteAll(in context: NSManagedObjectContext) {
        do {
            try fetch(in: context)
        } catch {
            
        }
    }
}
