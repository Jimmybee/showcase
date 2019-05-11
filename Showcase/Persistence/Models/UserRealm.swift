//
//  UserRealm.swift
//  Showcase
//
//  Created by James Birtwell on 11/05/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import RealmSwift

final class UserRealm: Object, RealmObject {
    typealias MemoryModel = User
    typealias RealmModel = UserRealm
    
    @objc dynamic var id:Int = 0
    @objc dynamic var name:String = ""
    
    convenience init(_ model: MemoryModel) {
        self.init()
        self.id = model.id
        self.name = model.name
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
