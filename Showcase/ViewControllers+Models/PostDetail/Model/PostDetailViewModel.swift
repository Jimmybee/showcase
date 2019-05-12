//
//  PostDetailViewModel.swift
//  Showcase
//
//  Created by James Birtwell on 12/05/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import RxSwift

struct PostDetailViewModel {
    
    let dataManager: RxDataManager
    let networkProvider: RxProvider
    let post: Post
    
    init(post: Post, dataManager: RxDataManager, networkProvider: RxProvider) {
        self.post = post
        self.dataManager = dataManager
        self.networkProvider = networkProvider
    }
    
    func headerData() -> PostDetailHeaderView.Model {
        let user: User? = dataManager.load(byId: post.userId)
        return (userName: user?.name ?? "Unknown", postTitle: post.title)
    }
    
    func getComments() -> Observable<[Comment]> {
        let comments: Single<[Comment]> = networkProvider.observeCodableRequest(route: JsonPlaceholder.comments(for: post))
        return comments.asObservable()
    }
}
