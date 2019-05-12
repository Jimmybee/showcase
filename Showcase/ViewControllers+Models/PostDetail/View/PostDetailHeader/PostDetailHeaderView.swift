//
//  PostDetailHeaderView.swift
//  Showcase
//
//  Created by James Birtwell on 12/05/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import UIKit

class PostDetailHeaderView: ReusableViewFromXib {
    typealias Model = (userName: String, postTitle: String)

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postTitleLabel: UILabel!
    
    
    func setup(model: Model) {
        userNameLabel.text = model.userName
        postTitleLabel.text = model.postTitle
    }
}
