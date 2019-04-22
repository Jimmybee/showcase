//
//  UIButton+Ext.swift
//  Showcase
//
//  Created by James Birtwell on 18/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    convenience init(asset: UIImage.Asset) {
        self.init()
        let image = UIImage(asset: asset)
        setImage(image, for: .normal)
    }
}

