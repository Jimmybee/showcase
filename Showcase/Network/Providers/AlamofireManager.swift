//
//  AlamofireManager.swift
//  Showcase
//
//  Created by James Birtwell on 15/05/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import Alamofire

class DefaultAlamofireManager: Alamofire.SessionManager {
    static let sharedManager: DefaultAlamofireManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 5 
        configuration.timeoutIntervalForResource = 5
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return DefaultAlamofireManager(configuration: configuration)
    }()
}
