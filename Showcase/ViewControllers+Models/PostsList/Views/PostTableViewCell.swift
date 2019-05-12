//
//  PostTableViewCell.swift
//  Showcase
//
//  Created by James Birtwell on 12/05/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    private let postTitleLabel = LargePrimaryLabel()
    
    var post: Post! {
        didSet {
            postTitleLabel.text = post.title
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder){
        fatalError("not implemented")
    }
    
    private func setup() {
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        addSubview(postTitleLabel)
    }
    
    private func setupConstraints() {
        postTitleLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(5)
            make.left.right.equalToSuperview().inset(20)
        }
        postTitleLabel.numberOfLines = 0
    }
}
