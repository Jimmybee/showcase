//
//  PostListSection+Item.swift
//  Showcase
//
//  Created by James Birtwell on 11/05/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import RxDataSources

enum PostListSectionItem: IdentifiableType, Equatable {
    typealias Identity = String
    
    case user(User)
    case post(Post)
    
    static func == (lhs: PostListSectionItem, rhs: PostListSectionItem) -> Bool {
        return lhs.identity == rhs.identity
    }
    
    var identity: String {
        switch self {
        case let .post(post):
            return "post-\(post.id)"
        case let .user(user):
            return "user-\(user.id)"
        }
    }
}

enum PostListSection {
    case section(items: [PostListSectionItem])
    
    public var identity: String {
        switch self {
        case .section(items: let items):
            return items.first?.identity ?? "no-user"
        }
    }
}

extension PostListSection: AnimatableSectionModelType {
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
        case .section(_):
            self = .section(items: items)
        }
    }
}
