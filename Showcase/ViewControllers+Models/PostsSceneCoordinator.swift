//
//  PostsListCoordinator.swift
//  Showcase
//
//  Created by James Birtwell on 27/05/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import UIKit
import RxSwift

class PostsSceneCoordinator: Coordinator {
    var identifier: String { return String(describing: PostsSceneCoordinator.self) }
    
    var childCoordinators: [String : Coordinator] = [:]
    
    private let window: UIWindow
    private let bag = DisposeBag()
    private let dataManager: DataManager
    private let networkProvider: NetworkProvider
    private var rvc: UINavigationController!
    
    init(window: UIWindow, dataManager: DataManager, networkProvider: NetworkProvider) {
        self.window = window
        self.dataManager = dataManager
        self.networkProvider = networkProvider
    }
    
    func start() {
        let vm = PostListViewModel(networkProvider: networkProvider, storageManager: dataManager)
        let vc = PostsListViewController(viewModel: vm)
        rvc = UINavigationController(rootViewController: vc)
        
        coordinate(viewModel: vm)
       
        window.rootViewController = rvc
        window.makeKeyAndVisible()
    }
    
    func finish() {
        
    }    
}

// MARK: - PostListViewModel
extension PostsSceneCoordinator {
    private func coordinate(viewModel: PostListViewModelCoordinatorApi) {
        viewModel.observePostTapped.subscribe(onNext: { [weak self] (post) in
            guard let self = self else { return }
            self.goToDetailed(post: post)
        }).disposed(by: bag)
    }
    
    private func goToDetailed(post: Post) {
        let vm = PostDetailViewModel(post: post, dataManager: dataManager, networkProvider: networkProvider)
        let vc = PostDetailViewController(viewModel: vm)
        rvc.pushViewController(vc, animated: true)
    }
}
