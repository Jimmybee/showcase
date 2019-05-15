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
import RxSwiftExt
import RxCocoa

class RxPostListViewModel {
    
    private let bag = DisposeBag()
    private var networkProvider: RxNetworkProvider
    private var storageManager: DataManager
    
    private var openedUsers = BehaviorSubject<Set<Int>>(value: [])
    
    var loadingObserver = BehaviorRelay<Bool>(value: true)
    var errorObserver = PublishSubject<Error>()
    
    var userTappedObserver = PublishSubject<User>()

    init(networkProvider: RxNetworkProvider, storageManager: DataManager) {
        self.networkProvider = networkProvider
        self.storageManager = storageManager
        observeUserTapped()
    }
    
    func refreshData() {
        loadingObserver.accept(true)
        Observable.zip(updatePosts(), updateUsers())
            .mapTo(false)
            .catchErrorJustReturn(false)
            .bind(to: loadingObserver)
            .disposed(by: bag)
    }
    
    private func updatePosts() -> Observable<[Post]> {
        let posts: Single<[Post]> = networkProvider.observeCodableRequest(route: JsonPlaceholder.posts)
        return posts.do(onSuccess: { [weak self] (posts) in
            self?.storageManager.save(models: posts)
            }, onError: { [weak self] (error) in
                self?.errorObserver.onNext(error)
            }).asObservable()
    }
    
    private func updateUsers() -> Observable<[User]> {
        let users: Single<[User]> = networkProvider.observeCodableRequest(route: JsonPlaceholder.users)
        return users.do(onSuccess: { [weak self] (users) in
            self?.storageManager.save(models: users)
        }, onError: { [weak self] (error) in
            self?.errorObserver.onNext(error)
        }).asObservable()
    }
    
    var tablePosts: Driver<[PostListSection]> {
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
            .asDriver(onErrorJustReturn: [])
    }
    
    func observeUserTapped() {
        userTappedObserver.subscribe(onNext: { [weak self] (user) in
            guard var usersOpen = try? self?.openedUsers.value() else { return }
            if usersOpen.remove(user.id) == nil {
                usersOpen.insert(user.id)
            }
            self?.openedUsers.onNext(usersOpen)
        })
        .disposed(by: bag)
    }
}

