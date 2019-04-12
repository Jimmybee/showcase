//
//  ErrorExt.swift
//  Showcase
//
//  Created by James Birtwell on 06/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation

let logQueue: DispatchQueue = {
    let queue = DispatchQueue(label: "com.showcase.logQueue", attributes: [])
    return queue
}()

enum DebuggableLevel : String {
    case debug   = "DEBUG"
    case warning = "⚠️ WARNING"
    case error   = "❌ ERROR"
}

extension Error {
    func log(file: String = #file, line: Int = #line, function: String = #function) {
        let fileName = file.components(separatedBy: "/").last!
        var keys = ["FileName | Function | Line" : "\(fileName) | \(function) | \(line)"] as [String : Any]
        switch self {
        case let networkError as NetworkError:
            keys["Type"] = networkError.httpCode
            keys["Code"] = networkError.httpCode.rawValue
        case let clientError as ClientError:
            keys["Type"] = clientError.title
            keys["Code"] = clientError.code
            keys["Detail"] = clientError.detail
        case let nsError as NSError:
            nsError.userInfo.forEach { (key, value) in
                keys[key] = value
            }
        default:
            keys["LocalizedDescription"] = localizedDescription
        }
        
        log(dict: keys)
    }
    
    private func log(dict: [String: Any]) {
        logQueue.async {
            print("\(DebuggableLevel.error.rawValue)")
            dict.forEach { (key, value) in
                print(key + " : \(value)")
            }
        }
    }
}

func logD(_ message: String) {
    logQueue.async {
        print("\(DebuggableLevel.debug.rawValue) : \(message)")
    }
}
