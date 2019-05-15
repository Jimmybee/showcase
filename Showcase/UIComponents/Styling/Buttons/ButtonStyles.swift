//
//  ButtonStyles.swift
//  Showcase
//
//  Created by James Birtwell on 15/05/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import UIKit

extension UIButton : StyledTextObject {
    func set(style: StyleSize) {
        if let font = style.font {
            self.titleLabel?.font = font
        }
        self.setTitleColor(style.color, for: UIControl.State.normal)
        self.setTitleColor(style.color, for: UIControl.State.selected)
    }
}

class StyleButton: UIButton {
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


class LargeActionButton: StyleButton {
    override var defaultStyle: StyleSize {
        return  StyleSize(size: .large, style: .actionText)
    }
}
