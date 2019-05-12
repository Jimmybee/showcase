//
//  UISegmentedControl+Ext.swift
//  Showcase
//
//  Created by James Birtwell on 22/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import UIKit

protocol SegmentEnum: RawRepresentable where RawValue == Int {
    var title: String { get }
}

extension UISegmentedControl {
    func setup<T: SegmentEnum>(with segmemts: [T]) {
        removeAllSegments()
        segmemts.enumerated().forEach { (offset, segment) in
            insertSegment(withTitle: segment.title, at: offset, animated: false)
        }
    }
}
