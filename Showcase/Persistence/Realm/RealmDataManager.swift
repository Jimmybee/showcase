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

class RealmDataManager: PersistentDataManager, RxDataManager {
    func observe<T>(predicate: NSPredicate?) -> Observable<[T]> where T : PersistCoreData, T : PersistRealm {
        let results = realm.objects(T.RealmModel.self)
        let filterd = predicate != nil ? results.filter(predicate!) : results
        return Observable.collection(from: filterd, synchronousStart: false)
            .map{ $0.compactMap({ T($0) }) } 
    }
    
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
    
    func save<T: RealmSave>(models: [T]) {
        let realmModels = models.map({ $0.realmModel()  })
        do {
            realm.beginWrite()
            realm.add(realmModels, update: true)
            try realm.commitWrite()
        } catch {
            error.log()
        }
    }
    
    func load<T: PersistRealm>(predicate: NSPredicate?) -> [T] {
        let results = realm.objects(T.RealmModel.self)
        let filterd = predicate != nil ? results.filter(predicate!) : results
        return filterd.compactMap({ T($0) })
    }
    
}

protocol PersistentDataManager {
    func save<T: StandardSave>(models: [T])
    func load<T: CanPersist>(predicate: NSPredicate?) -> [T]
}

protocol RxDataManager {
    func observe<T: CanPersist>(predicate: NSPredicate?) -> Observable<[T]>
    func save<T: StandardSave>(models: [T])

}
