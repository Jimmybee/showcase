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
    case comments
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
        return [:]
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var parameters: [String: Any]? {
        return nil
    }
    
    var sampleData: Data {
        return "{{\"Implemented\": \"Nope\"}}".data(using: .utf8)!
        
        //            switch self {
        //            case .posts:
        //                let data = NSDataAsset(name: "PostTests", bundle: .main)?.data
        //                return data ?? Data()
        //            default:
        //                return "{{\"Implemented\": \"Nope\"}}".data(using: .utf8)!
        //            }
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
}

protocol NativeRouter {
    var nativeRequestUrl: URL { get }
}


extension JsonPlaceholder: NativeRouter {
    var nativeRequestUrl: URL {
        var url = baseURL
        url.appendPathComponent(path)
        return url
    }
}
