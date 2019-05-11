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
    associatedtype RealmModel: Object
    init?(_ object: RealmModel)
}

protocol RealmSaveable {
    associatedtype RealmModel: RealmObject
}

extension RealmSaveable {
    func realmModel() -> RealmModel {
        return RealmModel.init(self as! RealmModel.MemoryModel)
    }
}

