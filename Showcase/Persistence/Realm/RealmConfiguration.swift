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
    private (set) lazy var realmConfiguration: Realm.Configuration = {
        return Realm.Configuration(schemaVersion: schemaVersion, migrationBlock: migrationBlock, deleteRealmIfMigrationNeeded: false)
    }()
    
    init() {
        Realm.Configuration.defaultConfiguration = realmConfiguration
    }

    private func migrationBlock(migration: RealmSwift.Migration, oldSchemaVersion: UInt64) {
        
    }
    
}
