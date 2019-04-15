//
//  View+Ext.swift
//  Showcase
//
//  Created by James Birtwell on 15/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    var topSafeArea : CGFloat {
        var height: CGFloat = 0
        if #available(iOS 11, *) { // iPhone X basically
            height += UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
        }
        return height
    }
    
    var bottomSafeArea : CGFloat {
        var height: CGFloat = 0
        if #available(iOS 11, *) { // iPhone X basically
            height += UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        }
        return height
    }
}

