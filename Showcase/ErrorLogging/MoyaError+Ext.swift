//
//  MoyaError+Ext.swift
//  Showcase
//
//  Created by James Birtwell on 25/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import Moya

extension MoyaError: ShowcaseError {
    func appendKeys(to keys: inout [String : Any]) {
        keys["Type"] = httpCode
        keys["Code"] = httpCode.rawValue
    }
    
    var httpCode: HTTPStatusCode {
        switch self {
        case .statusCode(let response):
            return HTTPStatusCode(rawValue: response.statusCode) ?? HTTPStatusCode.unknown
        case .underlying(let error, _):
            return HTTPStatusCode(rawValue: error._code) ?? HTTPStatusCode.unknown
        case .objectMapping(_, _):
            return HTTPStatusCode(rawValue: 422) ?? HTTPStatusCode.unknown
        default:
            return HTTPStatusCode.unknown
        }
    }
    
    var rawErrorCode: String {
        switch self {
        case .statusCode(let response):
            return "Status: \(response.statusCode)"
        case .underlying(let error, _):
            return "Underlying: \(error._code):  \(error.localizedDescription)"
        case .objectMapping(_, _):
            return "Object Mapping: 422"
        default:
            return "Default: -1"
        }
    }
    
    var errorType: NetworkError {
        return NetworkError(response: nil, error: self)
    }
    
    var userAlertMessage: String? {
        return httpCode.userAlertMessage
    }
    
}
