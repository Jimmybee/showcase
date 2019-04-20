//
//  UIAlertContoller+Rx.swift
//  Showcase
//
//  Created by James Birtwell on 20/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//
// https://stackoverflow.com/questions/49538546/how-to-obtain-a-uialertcontroller-observable-reactivecocoa-or-rxswift
// With Enum improvements

import Foundation
import RxSwift
import UIKit

extension UIDevice {
    static var isPad : Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}

extension UIAlertController {
    struct AlertAction {
        var title: String?
        var rawValue: Int
        var style: UIAlertAction.Style
        
        static func action(title: String?, rawValue: Int, style: UIAlertAction.Style = .default) -> AlertAction {
            return AlertAction(title: title, rawValue: rawValue, style: style)
        }
    }
    
    /// sourceView for iPad
    static func present(
        in viewController: UIViewController,
        title: String?,
        message: String?,
        style: UIAlertController.Style,
        actions: [AlertAction],
        sourceView: UIView? = nil)
        -> Observable<AlertAction>
    {
        return Observable.create { observer in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
            if let sourceView = sourceView {
                alertController.popoverPresentationController?.sourceView = sourceView
            }
            if UIDevice.isPad, style == .actionSheet, let popover = alertController.popoverPresentationController {
                if popover.sourceView == nil, popover.sourceRect == .zero, popover.barButtonItem == nil {
                    assertionFailure("\(style) in iPad should have: popover.sourceView or popover.sourceRect or popover.barButtonItem")
                    popover.sourceView = viewController.view
                }
            }
            actions.forEach { action in
                let action = UIAlertAction(title: action.title, style: action.style) { _ in
                    observer.onNext(action)
                    observer.onCompleted()
                }
                alertController.addAction(action)
            }
            
            viewController.present(alertController, animated: true, completion: nil)
            return Disposables.create { alertController.dismiss(animated: true, completion: nil) }
        }
    }
}

enum AlertButton: Int {
    case edit, delete, cancel, remove, ok
    
    var action: UIAlertController.AlertAction {
        switch self {
        case .edit:
            return .action(title: "Edit", rawValue: rawValue, style: .default)
        case .delete:
            return .action(title: "Delete", rawValue: rawValue, style: .destructive)
        case .cancel:
            return .action(title: "Cancel", rawValue: rawValue, style: .cancel)
        case .remove:
            return .action(title: "Remove", rawValue: rawValue, style: .destructive)
        case .ok:
            return .action(title: "Ok", rawValue: rawValue, style: .default)
        }
    }
}

enum Alerts {
    case delete
    case ok
    
    private var buttons: [AlertButton] {
        switch self {
        case .delete:
            return [.delete, .cancel]
        case .ok:
            return [.ok]
        }
    }
    
    var actions: [UIAlertController.AlertAction] {
        return buttons.map({ $0.action })
    }
}
