//
//  NativeProvider.swift
//  Showcase
//
//  Created by James Birtwell on 06/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation

class NativeProvider: NSObject {
    
    func request<T: Codable>(type: JsonPlaceholder, handleSuccess: @escaping ((T) -> ()), handleError: @escaping ((Error) -> ())) {
        URLSession.shared.dataTask(with: type.requestUrl) { (data, response, error) in
            if let data = data {
                if let parsed = try? JSONDecoder().decode(T.self, from: data) {
                    handleSuccess(parsed)
                } else {
                    let e = ClientError.decodeFail("\(T.self)")
                    e.log()
                    handleError(e)
                }
            }
            if let error = error {
                let e = NetworkError(response: response, error: error)
                e.log()
                handleError(e)
            }
            }.resume()
    }
    
}



enum JsonPlaceholder {
    case posts
    case users
    case comments
}

extension JsonPlaceholder {
    var requestUrl: URL {
        var url = baseURL
        url.appendPathComponent(path)
        return url
    }
    
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
}

extension JsonPlaceholder { //TargetType
//    var method: Moya.Method {
//        return .get
//    }
//
//    var parameters: [String: Any]? {
//        return nil
//    }
//
//    var sampleData: Data {
//        switch self {
//        case .posts:
//            let data = NSDataAsset(name: "PostTests", bundle: .main)?.data
//            return data ?? Data()
//        default:
//            return "{{\"Implemented\": \"Nope\"}}".data(using: .utf8)!
//        }
//    }
//
//    var task: Task {
//        return .request
//    }
//
//    var parameterEncoding: ParameterEncoding {
//        return URLEncoding.default
//    }
}
