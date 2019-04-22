//
//  NetworkStrings.swift
//  Showcase
//
//  Created by James Birtwell on 22/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation

enum NetworkStrings: String, Localizable {
    case poor_connectivity
    case unknown
    
    var table: StringTable {
        return .Network
    }
}
