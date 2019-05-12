//
//  PostDetailViewContoller.swift
//  Showcase
//
//  Created by James Birtwell on 20/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class PostDetailViewController: UIViewController {
    
    let bag = DisposeBag()
    let header = PostDetailHeaderView()
    let commentTable = UITableView()
    let viewModel: PostDetailViewModel
    
    init(post: Post) {
        self.viewModel = PostDetailViewModel(post: post, dataManager: RealmDataManager.shared, networkProvider: MoyaShowcaseProvider.shared)
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    override func viewDidLoad() {
        addViews()
        constrainHeader()
        setupHeader()
        setupTable()
    }
    
    private func addViews() {
        view.addSubview(header)
        view.addSubview(commentTable)
    }
    
    private func constrainHeader() {
        let guides = view.safeAreaLayoutGuide
        header.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(guides)
        }
        
        commentTable.snp.makeConstraints { (make) in
            make.top.equalTo(header.snp.bottom)
            make.left.right.bottom.equalTo(guides)
        }
    }
    
    private func setupHeader() {
        header.setup(model: viewModel.headerData())
    }
  
    private func setupTable() {
        commentTable.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        viewModel.getComments()
            .bind(to: commentTable
                .rx
                .items(cellIdentifier: "Cell",
                       cellType: UITableViewCell.self)) {
                        row, comment, cell in
                        cell.textLabel?.text = comment.body
            }
            .disposed(by: bag)
    }
}
