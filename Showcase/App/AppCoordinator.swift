//
//  AppCoordinator.swift
//  Showcase
//
//  Created by James Birtwell on 27/05/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol Coordinator: class  {
    func start()
    func finish()
    var  identifier: String { get }
    var  childCoordinators: [String: Coordinator] { get set }
}

class AppCoordinator: Coordinator {
    var identifier: String { return String(describing: AppCoordinator.self) }
    var childCoordinators: [String : Coordinator] = [:]

    // MARK: - Properties
    let window: UIWindow?
    
    lazy var rootViewController: UINavigationController = {
        return UINavigationController(rootViewController: UIViewController())
    }()
    
    let networkManager: NetworkProvider = {
        return ShowcaseMoyaProvider()
    }()
    let dataManager: DataManager = {
        return RealmDataManager()
    }()
    
    // MARK: - Coordinator
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        guard let window = window else { return }
        let postCoordinator = PostsSceneCoordinator(window: window, dataManager: dataManager, networkProvider: networkManager)
        addChildCoordinator(postCoordinator)
        postCoordinator.start()
    }
    
    func finish() {
        
    }
}

extension Coordinator {
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators[coordinator.identifier] = coordinator
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        if childCoordinators[coordinator.identifier] == nil {
            
        }
        childCoordinators[coordinator.identifier] = nil
    }
}
