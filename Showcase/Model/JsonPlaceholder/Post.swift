//
//  Post.swift
//  BabylonPosts
//
//  Created by James Birtwell on 11/07/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//



import Foundation

struct Post: Codable, RealmLoadable, RealmLoadableById {
    typealias RealmModel = PostRealm
    
    let userId: Int
    let id: Int
    let title: String
    let body: String
            
    init?(_ postRealm: PostRealm) {
        self.userId = postRealm.userId
        self.id = postRealm.id
        self.title = postRealm.title ?? ""
        self.body = postRealm.body ?? ""
    }
}

