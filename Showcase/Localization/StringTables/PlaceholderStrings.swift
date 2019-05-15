//
//  PlaceholderStrings.swift
//  Showcase
//
//  Created by James Birtwell on 21/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation

enum PlaceholderStrings: String, Localizable {
    var table: StringTable {
        return .Placeholder
    }
    
    case posts_list
    case no_comments
    case comment_count
    case loading_comments
    case failed_loading
    
}
