//
//  MoyaProvider.swift
//  Showcase
//
//  Created by James Birtwell on 20/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import Moya
import RxMoya
import RxSwift

protocol RxNetworkProvider {
    func observeCodableRequest<T: Decodable, R: TargetType>(route: R) -> Single<T>
}

class RxMoyaProvider: RxNetworkProvider {
    static let shared = RxMoyaProvider()
    
    let provider = MoyaProvider<MultiTarget>() //(plugins: [NetworkLoggerPlugin(verbose: true)])

    func observeCodableRequest<T: Decodable, R: TargetType>(route: R) -> Single<T> {
        let multi = MultiTarget(route)
        return performMainRequest(token: multi)
            .map(T.self)
    }
    
    private func performMainRequest(token: MultiTarget) -> Single<Response> {
        
        return provider.rx.request(token).filterSuccessfulStatusCodes()
    }
}

