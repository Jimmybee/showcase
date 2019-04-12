//
//  LabelStyles.swift
//  Showcase
//
//  Created by James Birtwell on 10/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class UILocalizedLabel: UILabel {
    @IBInspectable var tableName: String? {
        didSet {
            guard let tableName = tableName else { return }
            text = text?.localized(tableName: tableName)
        }
    }
}


@IBDesignable class UILocalizedButton: UIButton {
    @IBInspectable var tableName: String? {
        didSet {
            guard let tableName = tableName else { return }
            let title = self.title(for: .normal)?.localized(tableName: tableName)
            setTitle(title, for: .normal)        }
    }
}
