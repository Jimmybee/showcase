//
//  AppDelegate.swift
//  Showcase
//
//  Created by James Birtwell on 06/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataManager.shared.saveContext()
    }

}

//https://medium.com/@marcosantadev/app-localization-tips-with-swift-4e9b2d9672c9


enum StringTable: String {
    case ITunes
}

protocol Localizable {
    var table: StringTable { get }
    var localized: String { get }
}

extension Localizable where Self: RawRepresentable, Self.RawValue == String {
    var localized: String {
        return rawValue.localized(tableName: table.rawValue)
    }
}

enum ITunesStrings: String, Localizable {
    case artist
    case itunes_music
    case blues
    case electronic
    case singer
    case jazz
    case hipHop
    case rock 
    
    
    var table: StringTable {
        return .ITunes
    }
}

extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
}
