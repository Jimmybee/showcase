//
//  PostListSection+Item.swift
//  Showcase
//
//  Created by James Birtwell on 11/05/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import RxDataSources

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
