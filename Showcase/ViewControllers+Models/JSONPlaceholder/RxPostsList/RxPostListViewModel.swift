//
//  RxPostListViewModel.swift
//  Showcase
//
//  Created by James Birtwell on 20/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class RxPostListViewModel {
    
    private let bag = DisposeBag()
    private var networkProvider: RxProvider
    private var storageManager: RxDataManager
    
    private var openedUsers = BehaviorSubject<Set<Int>>(value: [])
    
    var loading = Variable<Bool>(false)
    var tableTap = PublishSubject<PostListSectionItem>()
    var error = PublishSubject<Error>()
    
    init(networkProvider: RxProvider, storageManager: RxDataManager) {
        self.networkProvider = networkProvider
        self.storageManager = storageManager
        updatePosts()
        updateUsers()
        handleTableTap()
    }
    
    func updatePosts() {
        let posts: Single<[Post]> = networkProvider.observeCodableRequest(route: JsonPlaceholder.posts)
        posts.subscribe(onSuccess: { [weak self] (posts) in
            self?.storageManager.save(models: posts)
        }) { [weak self] (error) in
            self?.error.onNext(error)
        }.disposed(by: bag)
    }
    
    func updateUsers() {
        let posts: Single<[User]> = networkProvider.observeCodableRequest(route: JsonPlaceholder.users)
        posts.subscribe(onSuccess: { [weak self] (posts) in
            self?.storageManager.save(models: posts)
        }) { [weak self] (error) in
            self?.error.onNext(error)
            }.disposed(by: bag)
    }
    
    var tablePosts: Observable<[PostListSection]> {
        let users: Observable<[User]> = storageManager.observe(predicate: nil)
        let posts: Observable<[Post]> = storageManager.observe(predicate: nil)
        
        let groupedPosts = posts.map({ Dictionary(grouping: $0, by: { $0.userId}) })
        
        return Observable.combineLatest(users, groupedPosts, openedUsers.asObservable()) { (users, groupedPosts, openedUsers) -> [PostListSection] in
            let items = users.map { user -> [PostListSectionItem] in
                let userItem = [PostListSectionItem.user(user)]
                guard openedUsers.contains(user.id),
                    let posts = groupedPosts[user.id] else { return userItem }
                return userItem + posts.map{ PostListSectionItem.post($0)  }
            }
            return items.map{ PostListSection.section(items: $0) }
        }
    }
    
    var dataSource: RxTableViewSectionedReloadDataSource<PostListSection> {
        let dataSource =  RxTableViewSectionedReloadDataSource<PostListSection>(configureCell: { (dataSource, table, idxPath, model) in
                switch model{
                case let .post(post):
                    let cell = table.dequeueReusableCell(withIdentifier: UITableViewCell.identifier())!
                    cell.textLabel?.text = post.title
                    return cell
                case let .user(user):
                    let cell = table.dequeueReusableCell(withIdentifier: UITableViewCell.identifier())!
                    cell.textLabel?.text = user.name
                    return cell
                }
        })
        return dataSource
    }
    
    func handleTableTap() {
        tableTap.subscribe(onNext: { [weak self] (item) in
            switch item {
            case .post(let post):
                logD("\(post.id)")
            case .user(let user):
                guard var usersOpen = try? self?.openedUsers.value() else { return }
                if usersOpen.remove(user.id) == nil {
                    usersOpen.insert(user.id)
                }
                self?.openedUsers.onNext(usersOpen)
            }
        })
        .disposed(by: bag)
    }
}

