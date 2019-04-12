//
//  ITunesSearchQuerty.swift
//  Showcase
//
//  Created by James Birtwell on 12/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation

struct ITunesSearchQuery: Codable {
    let media: ITunesMedia  = .music
    let term: String
    let attribute: Attribute
    let limit: Int = 25
    let entity: Entity = .album
    
    init(term: String, attribute: Attribute) {
        self.term = term
        self.attribute = attribute
    }
    enum Entity: String, Codable {
        case musicArtist, musicTrack, album
    }
    
    enum Attribute: String, Codable {
        case artistTerm, songTerm, genreIndex
    }
}
