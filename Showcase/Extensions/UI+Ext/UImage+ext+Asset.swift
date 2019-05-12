//
//  ImageAssets.swift
//  Showcase
//
//  Created by James Birtwell on 10/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    convenience init?(asset: Asset) {
        self.init(named: asset.rawValue)
    }
    
    enum Asset: String {
        case close_icn
        case iTunes_flipped_Bg
    }
}
