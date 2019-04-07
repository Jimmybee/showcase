//
//  Comment.swift
//  BabylonPosts
//
//  Created by James Birtwell on 11/07/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//


import Foundation

struct Comment: Codable {
    
    var postId: Int
    var id: Int
    var name: String
    var email: String
    var body: String

}
