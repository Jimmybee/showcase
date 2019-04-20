//
//  UIImageView+Ext.swift
//  Showcase
//
//  Created by James Birtwell on 18/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    convenience init(asset: UIImage.Asset) {
        self.init()
        image = UIImage(asset: asset)
    }
}
