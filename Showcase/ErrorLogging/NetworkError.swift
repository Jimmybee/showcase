//
//  NetworkError.swift
//  Showcase
//
//  Created by James Birtwell on 06/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation

struct NetworkError: Error, ShowcaseError {
    let response: URLResponse?
    let error: Error
    
    init(response: URLResponse?, error: Error) {
        self.response = response
        self.error = error
    }
    
    var httpCode: HTTPStatusCode{
        let nsError = error as NSError
        return HTTPStatusCode(rawValue: nsError.code) ?? .unknown
    }
    
    var shouldRecord: Bool {
        switch self.httpCode {
        case .internetAppearsOffline, .requestTimeout:
            return false
        default:
            return true
        }
    }
    
    var userAlertMessage: String? {
        return httpCode.userAlertMessage
    }
    
    func appendKeys(to keys: inout [String : Any]) {
        keys["Type"] = httpCode
        keys["Code"] = httpCode.rawValue
    }
}
