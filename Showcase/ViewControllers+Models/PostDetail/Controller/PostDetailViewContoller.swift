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
    let viewModel: PostDetailViewModel
    
    init(post: Post) {
        self.viewModel = PostDetailViewModel(post: post, dataManager: RealmDataManager.shared, networkProvider: ShowcaseMoyaProvider.shared)
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
    }
    
    private func addViews() {
        view.addSubview(header)
    }
    
    private func constrainHeader() {
        let guides = view.safeAreaLayoutGuide
        header.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(guides)
        }
    }
    
    private func setupHeader() {
        header.setup(model: viewModel.headerData())
    }
}
