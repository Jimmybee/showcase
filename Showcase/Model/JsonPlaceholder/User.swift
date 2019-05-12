//
//  User.swift
//  BabylonPosts
//
//  Created by James Birtwell on 11/07/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation

struct User: Codable, RealmLoadable, RealmLoadableById {
    typealias RealmModel = UserRealm
    
    var id: Int
    var name: String
    
    init?(_ realmModel: RealmModel) {
        self.id = realmModel.id
        self.name = realmModel.name
    }
}
