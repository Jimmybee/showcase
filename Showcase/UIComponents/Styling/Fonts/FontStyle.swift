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

protocol StyledTextObject : class {
    func set(style: StyleSize)
}

struct StyleSize {
    var size: Size
    var style: Style
    
    var font: UIFont? {
        return UIFont(name: style.fontString, size: size.rawValue)
    }
    var color: UIColor {
        return style.color
    }
    
    enum Size: CGFloat {
        case small = 12
        case medium = 14
        case large = 20
    }
    
    enum Style {
        case primaryText, secondaryText, actionText
        
        var fontString: String {
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
                return .darkGray
            case .actionText:
                return UIColor.from(hexString: "#0075EB")
            }
        }
    }
}
