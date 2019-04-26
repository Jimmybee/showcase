//
//  UrlSessionProvider.swift
//  Showcase
//
//  Created by James Birtwell on 06/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol RxProvider {
    func observeCodableRequest<T: Decodable>(type: DualRouter) -> Single<T>
}

protocol UrlSessionRouter {
    var urlSessionUrl: URL { get }
}

class UrlSessionProvider: NSObject, RxProvider {
    
    static let shared = UrlSessionProvider()
    
    @discardableResult
    func codableRequest<T: Decodable>(type: DualRouter, handleSuccess: @escaping ((T) -> ()), handleError: @escaping ((Error) -> ())) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: type.urlSessionUrl) { (data, response, error) in
            if let data = data {
//                self.log(data: data)
                do {
                    let parsed = try JSONDecoder().decode(T.self, from: data)
                    handleSuccess(parsed)
                } catch {
                    let decodeError = (error as? DecodingError).debugDescription
                    let e = ClientError.decodeFail("\(T.self); \(decodeError)")
                    e.log()
                    handleError(e)
                }
            }
            if let error = error {
                let e = NetworkError(response: response, error: error)
                e.log()
                handleError(e)
            }
            }
        task.resume()
        return task
    }
    
    func dataRequest(type: DualRouter, handleSuccess: @escaping ((Data) -> ()), handleError: @escaping ((Error) -> ())) {
        URLSession.shared.dataTask(with: type.urlSessionUrl) { (data, response, error) in
            if let data = data {
//                self.log(data: data)
                handleSuccess(data)
            }
            if let error = error {
                let e = NetworkError(response: response, error: error)
                e.log()
                handleError(e)
            }
            }.resume()
    }
    
    func imageRequest(type: DualRouter, handleSuccess: @escaping((UIImage) -> ()), handleError: @escaping ((Error) -> ())) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: type.urlSessionUrl) { (data, response, error) in
            if let data = data,
                let image = UIImage(data: data) {
                handleSuccess(image)
            } else {
                let e = ClientError.unknownError("Image request failed")
                e.log()
                handleError(e)
            }
            if let error = error {
                let e = NetworkError(response: response, error: error)
                e.log()
                handleError(e)
            }
        }
        task.resume()
        return task
    }
    
    func log(data: Data) {
        print(data.prettyJson())
    }
}

extension UrlSessionProvider {
    func observeCodableRequest<T: Decodable>(type: DualRouter) -> Single<T> {
        return Single<T>.create { (single) -> Disposable in
            func handleSuccess(decodedObject: T) {
                single(.success(decodedObject))
            }
            
            let task = self.codableRequest(type: type, handleSuccess: handleSuccess, handleError: { single(.error($0))
            })
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

