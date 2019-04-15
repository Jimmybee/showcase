//
//  CollectionView+Ext.swift
//  Showcase
//
//  Created by James Birtwell on 15/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import UIKit

public extension UICollectionViewCell {
    
    class func identifier() -> String {
        return String(describing: self)
    }
    
}
