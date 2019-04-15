//
//  NetworkError.swift
//  Showcase
//
//  Created by James Birtwell on 06/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation

struct NetworkError: Error {
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
        switch self.httpCode {
        case .internetAppearsOffline, .requestTimeout:
            return NetworkStrings.poor_connectivity.localized
        default:
            return NetworkStrings.unknown.localized
        }
    }
}


extension Data {
    func prettyJson() -> String {
        guard !self.isEmpty else { return "Data is empty" }
        guard let json = try? JSONSerialization.jsonObject(with: self, options: []) else {
            return "Unable to map JSON with string: \n\(String(decoding: self, as: UTF8.self))"
        }
        func JSONStringify(value: Any) -> String {
            let options = JSONSerialization.WritingOptions.prettyPrinted
            if JSONSerialization.isValidJSONObject(value) {
                if let data = try? JSONSerialization.data(withJSONObject: value, options: options) {
                    if let string = String(data: data, encoding: String.Encoding.utf8) {
                        return string
                    }
                }
            }
            return "Failed to parse"
        }
        return JSONStringify(value: json)
    }

}
