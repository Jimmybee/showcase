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
    
    dynamic var userId:Int = 0
    dynamic var id:Int = 0
    dynamic var title: String?
    dynamic var body: String?
    
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
    
//    static func get() -> Results<PostRealm> {
//        let realm = try! Realm()
//        return realm.objects(PostRealm.self)
//    }
//
//    static func saveAll(posts: [Post], completion: () -> ()) {
//        let realm = try! Realm()
//        let current = PostRealm.get()
//        let realmPosts = posts.map({PostRealm($0)})
//        try! realm.write {
//           realm.delete(current)
//           realm.add(realmPosts)
//        }
//    }
}


