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
import RxCocoa
import RxOptional

class PostsListViewController: UIViewController {
    
    private let bag = DisposeBag()
    private let tableView = UITableView()
    private var viewModel: PostListViewModelViewApi
    private let loadingBar = LoadingBarView()
    private let refreshControl = UIRefreshControl()
    private let noContentView = NoContentView()
    
    init(viewModel: PostListViewModelViewApi) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNoContentView()
        constrainTable()
        setupTable()
        observeTableTap()
        observeViewModelErrors()
        observeLoading()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.refreshData()
    }
}

// MARK: Private - Setup
extension PostsListViewController {
    private func setupView() {
        view.addSubview(tableView)
        view.addSubview(loadingBar)
        navigationItem.title = PlaceholderStrings.posts_list.localized
        view.backgroundColor = .white
        let guide = view.safeAreaLayoutGuide
        loadingBar.snp.makeConstraints({ $0.top.left.right.equalTo(guide) })
    }
    
    private func constrainTable() {
        let guide = view.safeAreaLayoutGuide
        tableView.snp.makeConstraints { $0.edges.equalTo(guide) }
    }
    
    private func setupTable() {
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier())
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier())
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        
        viewModel.tablePosts
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        viewModel.tablePosts
            .map({[weak self] in self?.tableFooterViewFor(sectionCount: $0.count)})
            .filterNil()
            .drive(onNext: { [weak self] (view) in
                guard let self = self else { return }
                self.tableView.tableFooterView = view
            }).disposed(by: bag)
    }
    
    private func tableFooterViewFor(sectionCount: Int) -> UIView {
        if sectionCount > 0 {
            return UIView(frame: .zero)
        } else {
            noContentView.frame = tableView.frame
            return noContentView
        }
    }
    
    private func setupNoContentView() {
        noContentView.noContentLabel.text = PlaceholderStrings.no_posts.localized
        noContentView.noContentBttn.setTitle(PlaceholderStrings.try_again.localized, for: .normal)
        noContentView.action.drive(onNext: { [weak self] (_) in
            self?.viewModel.refreshData()
        }).disposed(by: bag)
    }
}

//MARK: Datasource
extension PostsListViewController {
    private var dataSource: RxTableViewSectionedAnimatedDataSource<PostListSection> {
        let dataSource =  RxTableViewSectionedAnimatedDataSource<PostListSection>(configureCell: { (dataSource, table, idxPath, model) in
            switch model{
            case let .post(post):
                let cell = table.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier()) as! PostTableViewCell
                cell.post = post
                return cell
            case let .user(user):
                let cell = table.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier()) as! UserTableViewCell
                cell.user = user
                return cell
            }
        })
        dataSource.animationConfiguration = AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .fade, deleteAnimation: .fade)
        return dataSource
    }
}

// MARK: Private handlers
extension PostsListViewController {
    private func observeViewModelErrors() {
        viewModel.errorObservable
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
            .subscribe()
            .disposed(by: bag)
    }
    
    private func observeTableTap() {
        tableView.rx.modelSelected(PostListSectionItem.self)
            .subscribe(onNext: { [weak self] (item) in
                guard let self = self else { return }
                self.viewModel.handleTableTapOn(item: item)
            })
            .disposed(by: bag)
    }
    
    private func observeLoading() {
        let isLoading = viewModel.loadingObservable
            .throttle(.milliseconds(1200), latest: true, scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: false)
        
        isLoading
            .drive(loadingBar.rx.animating)
            .disposed(by: bag)
        
        isLoading
            .drive(noContentView.noContentBttn.rx.isHidden)
            .disposed(by: bag)
    }
}
