//
//  Data+Ext.swift
//  Showcase
//
//  Created by James Birtwell on 22/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation

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
