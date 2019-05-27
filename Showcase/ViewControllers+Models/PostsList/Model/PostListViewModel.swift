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

protocol PostListViewModelViewApi {
    var loadingObservable: Observable<Bool> { get }
    var errorObservable: Observable<Error> { get }
    var tablePosts: Driver<[PostListSection]> { get }

    func refreshData()
    func handleTableTapOn(item: PostListSectionItem)
}

protocol PostListViewModelCoordinatorApi {
    var observePostTapped: Observable<Post> { get }
}

class PostListViewModel {
    private let bag = DisposeBag()
    private var networkProvider: NetworkProvider
    private var storageManager: DataManager
    private var openedUsers = BehaviorSubject<Set<Int>>(value: [])
    private let loadingRelay = BehaviorRelay<Bool>(value: true)
    private let errorSubject = PublishSubject<Error>()
    private let userTappedObserver = PublishSubject<User>()
    private let postTapped = PublishSubject<Post>()

    init(networkProvider: NetworkProvider, storageManager: DataManager) {
        self.networkProvider = networkProvider
        self.storageManager = storageManager
        observeUserTapped()
    }
}

// MARK: - Coordinator API
extension PostListViewModel: PostListViewModelCoordinatorApi {
    var observePostTapped: Observable<Post> {
        return postTapped.asObservable()
    }
}

// MARK: - View API
extension PostListViewModel: PostListViewModelViewApi {
    // Datasource
    var loadingObservable: Observable<Bool> {
        return loadingRelay.asObservable()
    }
    
    var errorObservable: Observable<Error> {
        return errorSubject.asObservable()
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
    
    // Events
    func refreshData() {
        loadingRelay.accept(true)
        Observable.zip(updatePosts(), updateUsers())
            .mapTo(false)
            .catchErrorJustReturn(false)
            .bind(to: loadingRelay)
            .disposed(by: bag)
    }

    func handleTableTapOn(item: PostListSectionItem) {
        switch item {
        case .post(let post):
            postTapped.onNext(post)
        case .user(let user):
            userTappedObserver.onNext(user)
        }
    }
}

// MARK: - Private
extension PostListViewModel {
    private func observeUserTapped() {
        userTappedObserver.subscribe(onNext: { [weak self] (user) in
            guard var usersOpen = try? self?.openedUsers.value() else { return }
            if usersOpen.remove(user.id) == nil {
                usersOpen.insert(user.id)
            }
            self?.openedUsers.onNext(usersOpen)
        })
            .disposed(by: bag)
    }
    
    private func updatePosts() -> Observable<[Post]> {
        let posts: Single<[Post]> = networkProvider.observeCodableRequest(route: JsonPlaceholder.posts)
        return posts.do(onSuccess: { [weak self] (posts) in
            self?.storageManager.save(models: posts)
            }, onError: { [weak self] (error) in
                self?.errorSubject.onNext(error)
        }).asObservable()
    }
    
    private func updateUsers() -> Observable<[User]> {
        let users: Single<[User]> = networkProvider.observeCodableRequest(route: JsonPlaceholder.users)
        return users.do(onSuccess: { [weak self] (users) in
            self?.storageManager.save(models: users)
            }, onError: { [weak self] (error) in
                self?.errorSubject.onNext(error)
        }).asObservable()
    }
}

