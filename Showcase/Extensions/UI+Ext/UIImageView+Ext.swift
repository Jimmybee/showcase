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

extension UIImage {
    static func block(color: UIColor) -> UIImage? {
        let rect =  CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
