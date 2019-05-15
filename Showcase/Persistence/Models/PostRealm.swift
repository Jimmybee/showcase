////
////  PostRealm.swift
////  BabylonPosts
////
////  Created by James Birtwell on 12/07/2017.
////  Copyright © 2017 James Birtwell. All rights reserved.
////
//
import Foundation
import RealmSwift

final class PostRealm: Object, RealmObject, RealmObjectWithId {
    typealias MemoryModel = Post
    typealias RealmModel = PostRealm
    
    @objc dynamic var userId:Int = 0
    @objc dynamic var id:Int = 0
    @objc dynamic var title: String?
    @objc dynamic var body: String?
    @objc dynamic var edit: String?

    
    convenience init(_ model: MemoryModel) {
        self.init()
        self.userId = model.userId
        self.id = model.id
        self.title = model.title
        self.body = model.body
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}


