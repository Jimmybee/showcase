//
//  RealmDataManager.swift
//  Showcase
//
//  Created by James Birtwell on 16/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxRealm

protocol RxDataManager {
    func save<T: RealmLoadable>(models: [T])
    func load<T: RealmLoadable>(predicate: NSPredicate?) -> [T]
    func load<T: RealmLoadableById>(byId id: Int) -> T? 
    func observe<T: RealmLoadable>(predicate: NSPredicate?) -> Observable<[T]>
}

class RealmDataManager: RxDataManager {
    var configuration : DataStoreConfiguration!
    
    init(realmConfiguration: Realm.Configuration? = nil) {
        self.configuration = DataStoreConfiguration(realmConfiguration: realmConfiguration)
    }
    
    static let shared = RealmDataManager()
   
    var realm: Realm {
        return try! Realm(configuration: configuration.realmConfiguration)
    }
    
    var logRealm : Realm? {
        guard configuration.hasCheckedConfiguration else { return nil }
        if _logRealm == nil { _logRealm = realm }
        return _logRealm
    }
    private var _logRealm : Realm?
    
    // MARK: Clear data (used on Unit Tests)
    func clearAllData() -> Bool {
        do {
            realm.beginWrite()
            realm.deleteAll()
            logD("commitWrite() \(Thread.current)")
            try realm.commitWrite()
        } catch {
            return false
        }
        return true
    }
    
    func save<T: RealmLoadable>(models: [T]) {
        let realmModels = models.map({ $0.realmModel() })
        do {
            realm.beginWrite()
            realm.add(realmModels, update: true)
            try realm.commitWrite()
        } catch {
            error.log()
        }
    }
    
    func load<T: RealmLoadable>(predicate: NSPredicate?) -> [T] {
        let results = realm.objects(T.RealmModel.self)
        let filterd = predicate != nil ? results.filter(predicate!) : results
        return filterd.compactMap({ T($0) })
    }
    
    func observe<T: RealmLoadable>(predicate: NSPredicate? = nil) -> Observable<[T]> {
        let results = realm.objects(T.RealmModel.self)
        let filterd = predicate != nil ? results.filter(predicate!) : results
        return Observable.collection(from: filterd, synchronousStart: false)
            .map{ $0.compactMap({ T($0) }) }
    }

    func load<T: RealmLoadableById>(byId id: Int) -> T? {
        let result = realm.object(ofType: T.RealmModel.self, forPrimaryKey: id)
        return result.flatMap{ T($0) }
    }
}
