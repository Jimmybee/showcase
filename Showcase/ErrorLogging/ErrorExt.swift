//
//  ErrorExt.swift
//  Showcase
//
//  Created by James Birtwell on 06/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation

protocol ShowcaseError {
    var userAlertMessage: String? { get }
    func appendKeys(to: inout [String: Any])
}

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
        case let showcaseError as ShowcaseError:
            showcaseError.appendKeys(to: &keys)           
        case let nsError as NSError:
            keys["ErrorDomain"] = "NSError"
            nsError.userInfo.forEach { (key, value) in
                keys[key] = value
            }
        default:
            keys["ErrorDomain"] = "Default"
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
    
    var userAlertMessage: String? {
        switch self {
        case let showcaseError as ShowcaseError:
            return showcaseError.userAlertMessage
        default:
            return "Unknown Error"
        }
    }
}

func logD(_ message: String) {
    let thread : String = Thread.current.isMainThread ? "M" : "BG"
    logQueue.async {
        print("\(DebuggableLevel.debug.rawValue) (\(thread)): \(message)")
    }
}
