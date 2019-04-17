//
//  PostCore+Ext.swift
//  Showcase
//
//  Created by James Birtwell on 07/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import CoreData

extension PostCore: CDCreatable, CoreDataModel {
    typealias MemoryModel = Post
    typealias CoreModel = PostCore
    
    static func create(in context: NSManagedObjectContext, post: Post) {
        let coreModel = PostCore(context: context)
        coreModel.id = Int64(post.id)
        coreModel.body = post.body
        coreModel.title = post.title
        coreModel.userId = Int64(post.userId)
    }
    
    
}
