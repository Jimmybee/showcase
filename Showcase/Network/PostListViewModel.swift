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

    private var networkProvider: NativeProvider
    private var storageManager: CoreDataManager
    
    init(networkProvider: NativeProvider, storageManager: CoreDataManager) {
        self.networkProvider = networkProvider
        self.storageManager = storageManager
       
    }
    
  
    
    func refreshRemoteData() {
        networkProvider.codableRequest(type: JsonPlaceholder.posts, handleSuccess: handle, handleError: handleError)
    }
    
    func handle(posts: [Post]) {
        let context = storageManager.persistentContainer.viewContext
        posts.forEach { PostCore.create(in: context, post: $0) }
        storageManager.saveContext()
    }
    
    func handleError(_ error: Error) {
        
    }
    
    func loadPosts() {
        guard let posts: [PostCore] = storageManager.getData() else {
            ClientError.unknownError("core data").log()
            return
        }
        self.posts = posts.map({ Post(model: $0) })
        refreshView?()
    }
    
}

extension PostListViewModel: CoreDataObserverDelegate {
    func contextDidSave() {
        loadPosts()
    }
}


