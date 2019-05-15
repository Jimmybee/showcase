//
//  ClientError.swift
//  Showcase
//
//  Created by James Birtwell on 06/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation

enum ClientError: Error, ShowcaseError {
    case decodeFail(String)
    case unknownError(String)
    
    var title: String{
        switch self {
        case .unknownError:
            return "Unknown Error"
        case .decodeFail:
            return "Decode Fail"
        }
    }
    
    var code: Int {
        switch self {
        case .unknownError:
            return -1001
        case .decodeFail:
            return 1001
        }
    }
    
    var detail: String {
        switch self {
        case let .decodeFail(detail), let .unknownError(detail):
            return detail
        }
    }
    
    var userAlertMessage: String? {
        switch self {
        case .decodeFail:
            return "Internal Client Error"
        default:
            return detail
        }
    }
    
    func appendKeys(to keys: inout [String : Any]) {
        keys["ErrorDomain"] = "ClientError"
        keys["Type"] = title
        keys["Code"] = code
        keys["Detail"] = detail
    }
}
