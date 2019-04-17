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

final class PostRealm: Object, RealmObject {
    typealias MemoryModel = Post
    typealias RealmModel = PostRealm
    
    @objc dynamic var userId:Int = 0
    @objc dynamic var id:Int = 0
    @objc dynamic var title: String?
    @objc dynamic var body: String?
    
    static func construct(model: Post) -> PostRealm {
        return PostRealm(model)
    }
    
    convenience init(_ post: Post) {
        self.init()
        self.userId = post.userId
        self.id = post.id
        self.title = post.title
        self.body = post.body
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}


