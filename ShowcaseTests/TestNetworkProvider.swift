//
//  TestNetworkProvider.swift
//  ShowcaseTests
//
//  Created by James Birtwell on 01/05/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import RxSwift
@testable import Showcase

class TestNetworkProvider: RxProvider {

    let cloud = Variable<[String : Any]>([:])
    var networkDelay: Double = 0.1

//    func codableRequest<T: Decodable, R: UrlSessionRouter>(route: R, handleSuccess: @escaping ((T) -> ()), handleError: @escaping ((Error) -> ())) -> URLSessionDataTask  {
//        let key = String(describing: R.self)
//
//
//    }

    func observeCodableRequest<T: Decodable, R: DualRouter>(route: R) -> Single<T> {
        let key = String(describing: R.self)
        return cloud.asObservable()
            .map{ $0[key] as? T }
            .filterNil()
            .asSingle()
            .delay(networkDelay, scheduler: MainScheduler.asyncInstance)
    }
}
