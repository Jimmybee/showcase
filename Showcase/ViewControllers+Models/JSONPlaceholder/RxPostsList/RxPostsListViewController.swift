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
    
    private let bag = DisposeBag()
    private let tableView = UITableView()
    private let viewModel: RxPostListViewModel
    
    init(viewModel: RxPostListViewModel) {
        self.viewModel =  viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        observeTableTap()
        observeViewModelErrors()
    }
    
    private func observeViewModelErrors() {
        viewModel.error.asObservable()
            .subscribe(onNext: { [weak self ] (err) in
                err.log()
                guard let self = self,
                    let message = err.userAlertMessage else { return }
                
                self.handleAlert(message: message)
            })
            .disposed(by: bag)
    }
    
    private func handleAlert(message: String) {
        UIAlertController
            .present(in: self, title: "", message: message, style: .alert, actions: Alerts.ok.actions)
            .subscribe().disposed(by: bag)
    }
    
    private func setupView() {
        view.addSubview(tableView)
        navigationItem.title = PlaceholderStrings.rx_posts_list.localized
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier())
        viewModel.tablePosts
            .bind(to: tableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: bag)
    }
    
    private func observeTableTap() {
        tableView.rx.modelSelected(PostListSectionItem.self)
            .bind(to: viewModel.tableTap)
            .disposed(by: bag)
    }
}

