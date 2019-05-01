//
//  TestDataManager.swift
//  ShowcaseTests
//
//  Created by James Birtwell on 01/05/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import RxSwift
@testable import Showcase

class TestDataManager: PersistentDataManager, RxDataManager {
    let dataStore = Variable<[String: Any]>([:])
    
    func save<T>(models: [T]) where T : CoreSave, T : RealmSave {
        let key = String(describing: T.self)
        dataStore.value[key] = models
    }
    
    func load<T>(predicate: NSPredicate?) -> [T] where T : PersistCoreData, T : PersistRealm {
        let key = String(describing: T.self)
        let object = dataStore.value[key]
        return object as? [T] ?? (object as? T).flatMap{ [$0] } ?? []
    }
    
    func observe<T>(predicate: NSPredicate?) -> Observable<[T]> where T : PersistCoreData, T : PersistRealm {
        let key = String(describing: T.self)
        return dataStore.asObservable()
            .map{ $0[key] as? [T] ?? ($0[key] as? T).flatMap{ [$0] } }
            .filterNil()
    }
}
