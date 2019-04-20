//
//  RealmConfiguration.swift
//  Showcase
//
//  Created by James Birtwell on 20/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import RealmSwift

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
