//
//  NativeProvider.swift
//  Showcase
//
//  Created by James Birtwell on 06/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation

class NativeProvider: NSObject {
    
    static let shared = NativeProvider()
    
    @discardableResult
    func codableRequest<T: Decodable>(type: NativeRouter, handleSuccess: @escaping ((T) -> ()), handleError: @escaping ((Error) -> ())) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: type.requestUrl) { (data, response, error) in
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
    
    func dataRequest(type: NativeRouter, handleSuccess: @escaping ((Data) -> ()), handleError: @escaping ((Error) -> ())) {
        URLSession.shared.dataTask(with: type.requestUrl) { (data, response, error) in
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
    
    func log(data: Data) {
        print(data.prettyJson())
    }
}

protocol NativeRouter {
    var requestUrl: URL { get }
}

