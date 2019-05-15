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

protocol DataManager {
    func save<T: RealmLoadable>(models: [T])
    func load<T: RealmLoadable>(predicate: NSPredicate?) -> [T]
    func load<T: RealmLoadableById>(byId id: Int) -> T? 
    func observe<T: RealmLoadable>(predicate: NSPredicate?) -> Observable<[T]>
}

class RealmDataManager: DataManager {
    
    static let shared = RealmDataManager()
    private var configuration = DataStoreConfiguration()

    private init() { }
    
    func getRealm() throws -> Realm {
        return try Realm(configuration: configuration.realmConfiguration)
    }
    
    func save<T: RealmLoadable>(models: [T]) {
        let realmModels = models.map({ $0.realmModel() })
        do {
            let realm = try getRealm()
            realm.beginWrite()
            realm.add(realmModels, update: true)
            try realm.commitWrite()
        } catch {
            error.log()
        }
    }
    
    func load<T: RealmLoadable>(predicate: NSPredicate?) -> [T] {
        do {
            let realm = try getRealm()
            let results = realm.objects(T.RealmModel.self)
            let filterd = predicate != nil ? results.filter(predicate!) : results
            return filterd.compactMap({ T($0) })
        } catch {
            error.log()
            return []
        }
    }
    
    func observe<T: RealmLoadable>(predicate: NSPredicate? = nil) -> Observable<[T]> {
        do {
            let results = try getRealm().objects(T.RealmModel.self)
            let filterd = predicate != nil ? results.filter(predicate!) : results
            return Observable.collection(from: filterd, synchronousStart: false)
                .map{ $0.compactMap({ T($0) }) }
                .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
        } catch {
            error.log()
            return Observable.error(error)
        }
      
    }

    func load<T: RealmLoadableById>(byId id: Int) -> T? {
        do {
            let result = try getRealm().object(ofType: T.RealmModel.self, forPrimaryKey: id)
            return result.flatMap{ T($0) }
        } catch {
            error.log()
            return nil
        }
    }
}
