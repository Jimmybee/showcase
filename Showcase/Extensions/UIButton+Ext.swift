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
    
    convenience init(title: String) {
        self.init()
        setTitle(title, for: .normal)
    }
}

extension UIButton {
    func setupAsControlBttn() {
        setTitleColor(.blue, for: .normal)
        setBackgroundImage(UIImage.block(color: .white), for: .normal)
        setTitleColor(.white, for: .selected)
        setBackgroundImage(UIImage.block(color: .blue), for: .selected)
        setTitleColor(.white, for: .disabled)
        setBackgroundImage(UIImage.block(color: .red), for: .disabled)
        backgroundColor = .white
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        contentEdgeInsets =  UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
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
