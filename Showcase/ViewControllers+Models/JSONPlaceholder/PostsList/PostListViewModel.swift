//
//  PostListViewModel.swift
//  Showcase
//
//  Created by James Birtwell on 08/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation

class PostListViewModel {
    
    var posts: [Post] = []
    var refreshView: VoidFunction?

    private var networkProvider: UrlSessionProvider
    private var storageManager: PersistentDataManager
    
    init(networkProvider: UrlSessionProvider, storageManager: PersistentDataManager) {
        self.networkProvider = networkProvider
        self.storageManager = storageManager
       
        refreshRemoteData()
    }
    
    func refreshRemoteData() {
        networkProvider.codableRequest(type: JsonPlaceholder.posts, handleSuccess: handle, handleError: handleError)
    }
    
    func handle(posts: [Post]) {
        storageManager.save(models: posts)
        loadPosts()
    }
    
    func handleError(_ error: Error) {
        
    }
    
    func loadPosts() {
        let posts: [Post] = storageManager.load(predicate: nil)
        logD("Loaded \(posts.count) posts")
        self.posts = posts //.map({ Post(model: $0) })
        refreshView?()
    }
    
}

extension PostListViewModel: CoreDataObserverDelegate {
    func contextDidSave() {
        loadPosts()
    }
}


