//
//  LabelStyles.swift
//  Showcase
//
//  Created by James Birtwell on 10/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import UIKit

class StyleLabel: UILabel {
    var fontStyle: Style.Font = .primaryText
    var size: Style.Size = .medium
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        font = UIFont(name: fontStyle.asString, size: size.rawValue)
        textColor = fontStyle.color
    }
}

class LargePrimaryLabel: StyleLabel {
    override func setup() {
        fontStyle = .primaryText
        size = .large
        super.setup()
    }
}

class LargeActionLabel: StyleLabel {
    override func setup() {
        fontStyle = .actionText
        size = .large
        super.setup()
    }
}

class MediumSecondaryLabel: StyleLabel {
    override func setup() {
        fontStyle = .secondaryText
        size = .medium
        super.setup()
    }
}
