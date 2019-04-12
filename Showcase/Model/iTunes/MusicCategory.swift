//
//  MusicCategory.swift
//  Showcase
//
//  Created by James Birtwell on 11/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation

enum MusicCategory: Int, CaseIterable  {
    case blues = 2
    case electronic = 7
    case singer = 10
    case jazz = 11
    case hipHop = 18
    case rock = 21
    
    var title: String {
        switch self {
        case .blues:
            return ITunesStrings.blues.localized
        case .electronic:
            return ITunesStrings.electronic.localized
        case .singer:
            return ITunesStrings.singer.localized
        case .jazz:
            return ITunesStrings.jazz.localized
        case .hipHop:
            return ITunesStrings.hipHop.localized
        case .rock:
            return ITunesStrings.rock.localized
        }
    }
    
}
