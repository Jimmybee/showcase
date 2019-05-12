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
    private var viewModel: RxPostListViewModel = RxPostListViewModel(networkProvider: MoyaShowcaseProvider.shared, storageManager: RealmDataManager.shared)
    private let loadingBar = LoadingBarView()
    private let refreshControl = UIRefreshControl()
    
//    init(viewModel: RxPostListViewModel) {
//        self.viewModel =  viewModel
//        super.init(nibName: nil, bundle: nil)
//        view.backgroundColor = .white
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        view.backgroundColor = .white
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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
    
    private func observeViewModelErrors() {
        viewModel.errorObserver.asObservable()
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
        view.addSubview(loadingBar)
        navigationItem.title = PlaceholderStrings.rx_posts_list.localized
        
        let guide = view.safeAreaLayoutGuide
        loadingBar.snp.makeConstraints({ $0.top.left.right.equalTo(guide) })
        loadingBar.snp.makeConstraints({ $0.height.equalTo(5) })
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
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
    var dataSource: RxTableViewSectionedAnimatedDataSource<PostListSection> {
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
    
    private func observeTableTap() {
        tableView.rx.modelSelected(PostListSectionItem.self)
            .subscribe(onNext: { [weak self] (item) in
                guard let self = self else { return }
                switch item {
                case .post(let post):
                    let vc = PostDetailViewController(post: post)
                    self.navigationController?.pushViewController(vc, animated: true)
                case .user(let user):
                    self.viewModel.userTappedObserver.onNext(user)
                }
            })
            .disposed(by: bag)
    }
    
    private func observeLoading() {
        viewModel.loadingObserver.asObservable()
            .throttle(.milliseconds(1200), latest: true, scheduler: MainScheduler.instance)
            .debug("loadingObserver")
            .subscribe(onNext: { (loading) in
                if loading {
                    self.loadingBar.startAnimating()
                } else {
                    self.loadingBar.stopAnimating()
                }
            })
            .disposed(by: bag)
    }
    
}
