//
//  CategoryCollectionViewCell.swift
//  Showcase
//
//  Created by James Birtwell on 11/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    var category: MusicCategory! {
        didSet {
            label.text = category.title
        }
    }
    
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addSubview(label)
        backgroundColor = UIColor(white: 1, alpha: 0.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: Padding.medium.rawValue),
            label.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -Padding.medium.rawValue)
            ])
    }
    
}
