//
//  RealmDataManager.swift
//  Showcase
//
//  Created by James Birtwell on 16/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDataManager: PersistentDataManager {
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
        let objects = realm.objects(T.RealmModel.self)
        let filterd = predicate != nil ? objects.filter(predicate!) : objects
        return filterd.compactMap({ T($0) })
    }
    
}

protocol PersistentDataManager {
    func save<T: StandardSave>(models: [T])
    func load<T: CanPersist>(predicate: NSPredicate?) -> [T]
}














final class DataStoreConfiguration {
    
    private let schemaVersion : UInt64 = 1
    
    private (set) var realmConfiguration: Realm.Configuration!
    
    var hasCheckedConfiguration = false
    
    init(realmConfiguration: Realm.Configuration? = nil) {
        self.realmConfiguration = {
            if let r = realmConfiguration {
                return r
            }
            return Realm.Configuration(schemaVersion: schemaVersion, migrationBlock: migrationBlock, deleteRealmIfMigrationNeeded: false)
        }()
        Realm.Configuration.defaultConfiguration = self.realmConfiguration
    }
    
    func checkConfiguration() {
        
        do {
            _ = try Realm(configuration: realmConfiguration)
            logD("Realm initialized. Configuration schemaVersion \(realmConfiguration.schemaVersion). Actual schemaVersion: \(realmConfiguration.schemaVersion)")
        } catch let error {
//            logD("Controlled Realm error. Configuration schemaVersion \(realmConfiguration.schemaVersion). Trying to delete current file and logout if necessary", error: error)
            let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
            let realmURLs = [
                realmURL,
                realmURL.appendingPathExtension("lock"),
                realmURL.appendingPathExtension("note"),
                realmURL.appendingPathExtension("management")
            ]
            for URL in realmURLs {
                do {
                    try FileManager.default.removeItem(at: URL)
                } catch let error {
//                    logD("We failed to delete current Realm files after a Realm error.", error: error)
                }
            }
        }
        
        hasCheckedConfiguration = true
    }
    
    private func migrationBlock(migration: RealmSwift.Migration, oldSchemaVersion: UInt64) {

    }
    
}
