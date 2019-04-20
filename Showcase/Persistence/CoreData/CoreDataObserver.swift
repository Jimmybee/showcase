//
//  CoreDataObserver.swift
//  Showcase
//
//  Created by James Birtwell on 17/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation

// MARK: - CoreDataObserverDelegate
extension CoreDataManager: CoreDataObserverDelegate {
    func contextDidSave() {
        //        print("saved")
    }
}

protocol CoreDataObserverDelegate: class {
    func contextDidSave()
}

final class CoreDataObserver {
    
    weak var delegate: CoreDataObserverDelegate?
    
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.contextSave(_ :)),
                                               name: NSNotification.Name.NSManagedObjectContextDidSave,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

fileprivate extension CoreDataObserver {
    @objc
    func contextSave(_ notification: Notification) {
        //            guard let moc = notification.object as? else { return }
        print(notification.object)
        delegate?.contextDidSave()
    }
}
