//
//  PostsModelSelectionViewModel.swift
//  Showcase
//
//  Created by James Birtwell on 22/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import RxSwift

class PostSelectionViewModel {
   
    let persistenceOptions = Persistence.allCases
    let viewBindingOptions = ViewBinding.allCases
    let networkOptions = Network.allCases

    let selectedPersistence = Variable<Persistence>(.realm)
    let selectedViewBinding = Variable<ViewBinding>(.imperative)
    let selectedNetwork = Variable<Network>(.urlSession)
    
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
}

