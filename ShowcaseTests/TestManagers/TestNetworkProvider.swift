//
//  TestNetworkProvider.swift
//  ShowcaseTests
//
//  Created by James Birtwell on 01/05/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import RxSwift
import RxOptional
import RxTest
import Moya
@testable import Showcase

class TestNetworkProvider: NetworkProvider {

    private var cloud = [String : Any]()
    private var scheduler: TestScheduler!

    init(scheduler: TestScheduler?) {
        self.scheduler = scheduler
    }
    
    func add<T: Codable>(result: T, time: Int) {
        let key = String(describing: T.self)
        cloud[key] = createSingle(result: result, at: time)
    }
    
    private func createSingle<T: Codable>(result: T, at time: Int) -> Single<T> {
        var observer: ((SingleEvent<T>) -> Void)? = nil
        scheduler.scheduleAt(time, action: {
            observer?(.success(result))
        })
        return Single<T>.create { _observer in
            observer = _observer
            return Disposables.create {}
        }
    }
    
    func observeCodableRequest<T: Decodable, R: TargetType>(route: R) -> Single<T> {
        let key = String(describing: T.self)
        guard let single = cloud[key] as? Single<T> else {
            logD("No network scheduler set for \(key)")
            return Single.error(NSError())
        }
        return single
    }

}
