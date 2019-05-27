//
//  PostDetailViewModel.swift
//  Showcase
//
//  Created by James Birtwell on 12/05/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import RxSwift

protocol PostDetailViewModeViewApi {
    func headerData() -> PostDetailHeaderView.Model
}

struct PostDetailViewModel {
    private let dataManager: DataManager
    private let networkProvider: NetworkProvider
    private let post: Post
    
    init(post: Post, dataManager: DataManager, networkProvider: NetworkProvider) {
        self.post = post
        self.dataManager = dataManager
        self.networkProvider = networkProvider
    }
    
    private func getCommentCount() -> Observable<Int> {
        let comments: Single<[Comment]> = networkProvider.observeCodableRequest(route: JsonPlaceholder.comments(for: post))
        return comments.asObservable().map{ $0.count }
    }
}

extension PostDetailViewModel: PostDetailViewModeViewApi {
    func headerData() -> PostDetailHeaderView.Model {
        let user: User? = dataManager.load(byId: post.userId)
        return (userName: user?.name ?? "Unknown",
                postTitle: post.title,
                postBody: post.body,
                commentCount: getCommentCount())
    }
}
