//
//  Dictionary+Ext.swift
//  Showcase
//
//  Created by James Birtwell on 17/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation

extension Dictionary {
    var queryString: String? {
        return self.map { (key, value) -> String in
            return "\(key)=\(value)"
            }
            .joined(separator: "&")
    }
}
