//
//  Encodable+Ext.swift
//  Showcase
//
//  Created by James Birtwell on 17/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation

extension Encodable {
    var dictionary: [String: AnyObject]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: AnyObject] }
    }
}
