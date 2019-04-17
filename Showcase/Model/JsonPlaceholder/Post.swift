//
//  Post.swift
//  BabylonPosts
//
//  Created by James Birtwell on 11/07/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//



import Foundation

struct Post: Codable, CanPersist {
    typealias CoreModel = PostCore
    typealias RealmModel = PostRealm
    
    var userId: Int
    var id: Int
    var title: String
    var body: String
            
    init?(_ postRealm: PostRealm) {
        self.userId = postRealm.userId
        self.id = postRealm.id
        self.title = postRealm.title ?? ""
        self.body = postRealm.body ?? ""
    }
    
    init?(_ model: PostCore) {
        id = Int(model.id)
        body = model.body ?? ""
        title = model.title ?? ""
        userId = Int(model.userId)
    }
    
}

