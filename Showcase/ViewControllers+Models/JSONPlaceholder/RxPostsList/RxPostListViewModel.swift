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
    
    var loading = Variable<Bool>(false)
    var tableTap = PublishSubject<PostListSectionItem>()
    var error = PublishSubject<Error>()
    
    init(networkProvider: RxProvider, storageManager: RxDataManager) {
        self.networkProvider = networkProvider
        self.storageManager = storageManager
        updatePosts()
        handleTableTap()
    }
    
    func updatePosts() {
        let posts: Single<[Post]> = networkProvider.observeCodableRequest(route: JsonPlaceholder.posts)
        posts.subscribe(onSuccess: { [weak self] (posts) in
            self?.storageManager.save(models: posts)
        }) { (err) in
            self.error.onNext(err)
        }.disposed(by: bag)
    }
    
    var tablePosts: Observable<[PostListSection]> {
        return storageManager.observe(predicate: nil)
            .map{ $0.map{ PostListSectionItem.post($0) } }
            .map{ [PostListSection.section(items: $0)] }
    }
    
    var dataSource: RxTableViewSectionedReloadDataSource<PostListSection> {
        let dataSource =  RxTableViewSectionedReloadDataSource<PostListSection>(configureCell: { (dataSource, table, idxPath, model) in
                switch model{
                case let .post(post):
                    let cell = table.dequeueReusableCell(withIdentifier: UITableViewCell.identifier())!
                    cell.textLabel?.text = post.title
                    return cell
                default:
                    let cell = table.dequeueReusableCell(withIdentifier: UITableViewCell.identifier())!
                    cell.textLabel?.text = "user"
                    return cell
                }
        })
        return dataSource
    }
    
    func handleTableTap() {
        tableTap.subscribe(onNext: { (item) in
            switch item {
            case .post(let post):
                logD("\(post.id)")
            case .user(let user):
                logD("\(user.id)")
            }
        })
        .disposed(by: bag)
    }
}




enum PostListSectionItem {
    case user(User)
    case post(Post)
}

enum PostListSection {
    case section(items: [PostListSectionItem])
    
    public var identity: String {
        return "onesection"
    }
}

extension PostListSection: SectionModelType {
    typealias Identity = String
    
    typealias Item = PostListSectionItem
    
    var items: [Item] {
        switch self {
        case let .section(items):
            return items.map {$0}
        }
    }
    
    init(original: PostListSection, items: [Item]) {
        switch original {
        case let .section(items):
            self = .section(items: items)
        }
    }
}
