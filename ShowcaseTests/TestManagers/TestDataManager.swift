//
//  TestDataManager.swift
//  ShowcaseTests
//
//  Created by James Birtwell on 01/05/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import RxSwift
import RxTest
import XCTest

@testable import Showcase

class TestDataManager: DataManager {
    
    var dataManager = [String: Any]()
    var schedulerObservables = [String: Any]()
    var scheduler: TestScheduler!

    func save<T>(models: [T]) where T : RealmLoadable {
        let key = String(describing: T.self)
        dataManager[key] = models
    }
    
    func load<T>(predicate: NSPredicate?) -> [T] where T : RealmLoadable {
        let key = String(describing: T.self)
        let object = dataManager[key]
        return object as? [T] ?? (object as? T).flatMap{ [$0] } ?? []
    }
    
    func load<T>(byId id: Int) -> T? where T : RealmLoadableById {
        let key = String(describing: T.self)
        let all = dataManager[key] as? [T] ?? (dataManager[key] as? T).flatMap{ [$0] } ?? []
        return all.first(where: { $0.id == id })
    }
    
    func observe<T>(predicate: NSPredicate?) -> Observable<[T]> where T : RealmLoadable {
        let key = String(describing: T.self)
        guard let schedulerObservable = schedulerObservables[key] as? TestableObservable<[T]> else {
            XCTFail()
            return Observable.error(ClientError.unknownError("test fail"))
        }
        return schedulerObservable.asObservable()
    }
}
