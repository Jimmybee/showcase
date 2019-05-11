//
//  PostsModelSelectionViewModel.swift
//  Showcase
//
//  Created by James Birtwell on 22/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class PostsModelSelectionViewModel {
   
    let persistenceOptions = Persistence.allCases
    let viewBindingOptions = ViewBinding.allCases
    let networkOptions = Network.allCases

    let selectedPersistence = Variable<Persistence>(.realm)
    let selectedViewBinding = Variable<ViewBinding>(.imperative)
    let selectedNetwork = Variable<Network>(.urlSession)
    
    func enableCoreData() -> Observable<SegmententValid<Persistence>> {
        return selectedViewBinding.asObservable()
            .map{ SegmententValid(segment: .coreData, valid: $0 == .imperative) }
    }
    
    func enableMoya() -> Observable<SegmententValid<Network>> {
        return selectedViewBinding.asObservable()
            .map{ SegmententValid(segment: .moya, valid: $0 == .rx) }
    }
    
    func handleOpenPostsTap() -> UIViewController? {
        guard let vc = selectedViewBinding.value.viewController(network: selectedNetwork.value, persistence: selectedPersistence.value) else {
            return nil
        }
        return vc
    }
    
}



enum Persistence: Int, SegmentEnum, CaseIterable {
    case realm, coreData
    
    var title: String {
        switch self {
        case .realm:
            return PlaceholderStrings.realm.localized
        case .coreData:
            return PlaceholderStrings.core_data.localized
        }
    }
    
    var imperativeDataManager: PersistentDataManager {
        switch self {
        case .realm:
            return RealmDataManager.shared
        case .coreData:
            return CoreDataManager.shared
        }
    }
    
    var rxManager: RxDataManager? {
        switch self {
        case .realm:
            return RealmDataManager.shared
        default:
            return nil
        }
    }
}

enum Network: Int, SegmentEnum, CaseIterable {
    case urlSession, moya
    
    var title: String {
        switch self {
        case .urlSession:
            return PlaceholderStrings.url_session.localized
        case .moya:
            return PlaceholderStrings.moya.localized
        }
    }
    
    var imperativeNetworkProvider: NetworkProvider? {
        switch self {
        case .urlSession:
            return UrlSessionProvider.shared
        case .moya:
            return nil
        }
    }
    
    var rxProvider: RxProvider {
        switch self {
        case .urlSession:
            return UrlSessionProvider.shared
        case .moya:
            return MoyaShowcaseProvider.shared
        }
    }
}

enum ViewBinding: Int, SegmentEnum, CaseIterable {
    case imperative, rx
    
    var title: String {
        switch self {
        case .imperative:
            return PlaceholderStrings.imperative.localized
        case .rx:
            return PlaceholderStrings.rx.localized
        }
    }
    
    func viewController(network: Network, persistence: Persistence) -> UIViewController? {
        switch self {
        case .imperative:
            guard let network = network.imperativeNetworkProvider else { return nil }
            let storageManager = persistence.imperativeDataManager
            return imperativeViewController(provider: network, storageManager: storageManager)
        case .rx:
            guard let storageManager = persistence.rxManager else { return nil}
            let network = network.rxProvider
            return reactiveViewController(provider: network, storageManager: storageManager)
        }
    }
    
    private func imperativeViewController(provider: NetworkProvider, storageManager: PersistentDataManager) -> PostsListViewController {
        let viewModel = PostListViewModel(networkProvider: provider, storageManager: storageManager)
        return PostsListViewController(viewModel: viewModel)
    }
    
    private func reactiveViewController(provider: RxProvider, storageManager: RxDataManager) -> RxPostsListViewController {
        let viewModel = RxPostListViewModel(networkProvider: provider, storageManager: storageManager)
        return RxPostsListViewController(viewModel: viewModel)
    }
}

