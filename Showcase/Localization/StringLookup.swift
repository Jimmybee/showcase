//
//  StringLookup.swift
//  Showcase
//
//  Created by James Birtwell on 15/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

//https://medium.com/@marcosantadev/app-localization-tips-with-swift-4e9b2d9672c9

import Foundation

protocol Localizable {
    var table: StringTable { get }
    var localized: String { get }
}

enum StringTable: String {
    case ITunes
    case Network
    case Placeholder
}

extension Localizable where Self: RawRepresentable, Self.RawValue == String {
    var localized: String {
        return rawValue.localized(tableName: table.rawValue)
    }
}

extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
}
