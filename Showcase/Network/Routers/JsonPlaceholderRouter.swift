//
//  JsonPlaceholderRouter.swift
//  Showcase
//
//  Created by James Birtwell on 08/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import Moya

enum JsonPlaceholder {
    case posts
    case users
    case comments(for: Post)
}

extension JsonPlaceholder: TargetType {
    
    var baseURL: URL { return URL(string: "https://jsonplaceholder.typicode.com")! }
    
    var path: String {
        switch self {
        case .posts:
            return "/posts"
        case .users:
            return "/users"
        case .comments:
            return "/comments"
        }
    }
    
    var headers: [String : String]? {
        return DefaultAlamofireManager.defaultHTTPHeaders
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return "{{\"Implemented\": \"Nope\"}}".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .comments(for: let post):
            let parameters = ["postId": post.id]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
}
