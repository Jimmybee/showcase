//
//  FontStyle.swift
//  Showcase
//
//  Created by James Birtwell on 08/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import UIKit

enum CustomFont: String {
    case roboto = "Roboto-Regular"
}


struct Style {
    enum Size: CGFloat {
        case small = 12
        case medium = 14
        case large = 20
    }
    
    enum Font {
        case primaryText, secondaryText, actionText
        
        var asString: String {
            switch self {
            case .primaryText, .secondaryText, .actionText:
                return CustomFont.roboto.rawValue
            }
        }
        
        var color: UIColor {
            switch self {
            case .primaryText:
                return .black
            case .secondaryText:
                return .lightGray
            case .actionText:
                return UIColor.from(hexString: "#0075EB")
            }
        }
    }
}
