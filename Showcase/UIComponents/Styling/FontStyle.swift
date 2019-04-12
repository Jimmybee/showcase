//
//  FontStyle.swift
//  Showcase
//
//  Created by James Birtwell on 08/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import UIKit

enum Padding: CGFloat {
    case small = 8
    case medium = 10
    case margin = 20
}

struct FontStyle {
    
    enum Size: CGFloat {
        case small = 12
        case medium = 14
        case large = 16
        case veryLarge = 18
    }
    
    enum Font {
        case paragraph, paragraphHighlight, subtitle, title, error, warning, actionable, selected, italic, editableTitle
        
        var asString: String {
            switch self {
            case .paragraph, .subtitle, .editableTitle:
                return FontNames.Helvetica.normal.rawValue
            case .title, .warning, .error:
                return FontNames.Helvetica.normal.rawValue
            case .actionable, .selected, .paragraphHighlight:
                return FontNames.Helvetica.normal.rawValue
            case .italic:
                return  FontNames.Helvetica.normal.rawValue
            }
        }
        
        var boldness: Boldness {
            switch self {
            case .paragraph, .paragraphHighlight, .subtitle, .italic, .editableTitle:
                return .regular
            case .title, .warning, .error:
                return .bold
            case .actionable, .selected:
                return .semiBold
            }
        }
        
        var color: UIColor {
            switch self {
            case .paragraph, .paragraphHighlight, .italic:
                return UIColor.gray
            case .error:
                return UIColor.red
            case .subtitle, .title, .editableTitle:
                return UIColor.darkGray
            case .actionable:
                return UIColor.blue
            case .selected:
                return UIColor.white
            case .warning:
                return UIColor.orange
            }
        }
        
        var textAlignment: NSTextAlignment {
            switch self {
            case .paragraph, .paragraphHighlight, .italic, .editableTitle:
                return .left
            case .warning, .error:
                return .left
            case .title, .actionable, .selected, .subtitle:
                return .center
            }
        }
    }
}

enum Boldness {
    case regular, semiBold, bold
    
    var traits: [UIFontDescriptor.TraitKey: UIFont.Weight] {
        switch self {
        case .regular:
            return [UIFontDescriptor.TraitKey.weight : UIFont.Weight.regular]
        case .semiBold:
            return [UIFontDescriptor.TraitKey.weight : UIFont.Weight.semibold]
        case .bold:
            return [UIFontDescriptor.TraitKey.weight : UIFont.Weight.bold]
        }
    }
    
}

enum FontNames {
    enum Helvetica: String {
        case normal = "HelveticaNeue"
        case bold = "HelveticaNeue-Bold"
    }
}
