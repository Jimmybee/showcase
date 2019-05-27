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
    private var appCoordinator: AppCoordinator!

    func applicationDidFinishLaunching(_ application: UIApplication) {
        window = UIWindow()
        appCoordinator = AppCoordinator(window: window)
        appCoordinator.start()
    }

}
