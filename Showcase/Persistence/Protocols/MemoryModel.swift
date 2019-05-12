//
//  MemoryModel.swift
//  Showcase
//
//  Created by James Birtwell on 16/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import RealmSwift
import CoreData

protocol RealmLoadable {
    associatedtype RealmModel: RealmObject
    init?(_ object: RealmModel)
}

extension RealmLoadable {
    func realmModel() -> RealmModel {
        return RealmModel.init(self as! RealmModel.MemoryModel)
    }
}

protocol RealmLoadableById {
    associatedtype RealmModel: RealmObjectWithId
    init?(_ object: RealmModel)
    
    var id: Int { get }
}
