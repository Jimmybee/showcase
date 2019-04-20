//
//  RxPostsList.swift
//  Showcase
//
//  Created by James Birtwell on 20/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxDataSources
import RxSwift

class RxPostsListViewController: UIViewController {
    
    let bag = DisposeBag()
    let tableView = UITableView()
    let viewModel = RxPostListViewModel(networkProvider: MoyaShowcaseProvider.shared, storageManager: RealmDataManager.shared)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        observeTableTap()
    }
    
    func setupView() {
        view.addSubview(tableView)
        navigationItem.title = "Rx Post List"
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier())
        viewModel.tablePosts
            .bind(to: tableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: bag)
    }
    
    func observeTableTap() {
        tableView.rx.modelSelected(PostListSectionItem.self)
            .bind(to: viewModel.tableTap)
            .disposed(by: bag)
    }
}

