//
//  TestNetworkProvider.swift
//  ShowcaseTests
//
//  Created by James Birtwell on 01/05/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import RxSwift
import RxTest
import Moya
@testable import Showcase

class TestNetworkProvider: RxProvider {

    let cloud = [String : Any]()
    var schedulerTime: Int = 10
    var scheduler: TestScheduler!

    func observeCodableRequest<T: Decodable, R: TargetType>(route: R) -> Single<T> {
        let key = String(describing: R.self)
        let result = cloud[key] as? T
        
        return scheduler.createColdObservable([.next(schedulerTime, (result))])
            .errorOnNil()
            .asSingle()
    }
}
