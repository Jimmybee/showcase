//
//  LabelStyles.swift
//  Showcase
//
//  Created by James Birtwell on 10/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import UIKit

extension UILabel: StyledTextObject  {
    func set(style: StyleSize) {
        font = style.font
        textColor = style.color
    }
}

class StyleLabel: UILabel {
    var styleSize: StyleSize = StyleSize(size: .large, style: .primaryText) {
        didSet {
            set(style: styleSize)
        }
    }
    
    var defaultStyle: StyleSize {
        return  StyleSize(size: .large, style: .primaryText)
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        styleSize = defaultStyle
        set(style: styleSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        styleSize = defaultStyle
        set(style: styleSize)
    }
}

class LargePrimaryLabel: StyleLabel {
    override var defaultStyle: StyleSize {
        return  StyleSize(size: .large, style: .primaryText)
    }
}

class LargeActionLabel: StyleLabel {
    override var defaultStyle: StyleSize {
        return  StyleSize(size: .large, style: .actionText)
    }
}

class MediumSecondaryLabel: StyleLabel {
    override var defaultStyle: StyleSize {
        return  StyleSize(size: .medium, style: .secondaryText)
    }
}
