//
//  UserTableViewCell.swift
//  Showcase
//
//  Created by James Birtwell on 12/05/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    private let userNameLabel = LargePrimaryLabel()

    var user: User! {
        didSet {
            userNameLabel.text = user.name
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
        separatorInset = .zero
        backgroundColor = .lightText
        addSubview(userNameLabel)
    }
    
    private func setupConstraints() {
        userNameLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(20)
        }
    }
}
