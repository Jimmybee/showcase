//
//  MusicAlbum.swift
//  Showcase
//
//  Created by James Birtwell on 11/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
//https://itunes.apple.com/lookup?id=406148755

struct MusicAlbum: Codable {
    
    let collectionId: Int
    let artistId: Int
    let artistName: String
    let primaryGenreName: String
    let artworkUrl100: String
    let collectionName: String
    
    fileprivate init(entry: Entry) {
        collectionId = Int(entry.id.attributes.id) ?? 0
        artistId = 0
        artistName = entry.artist.label
        primaryGenreName = entry.category.attributes.label
        artworkUrl100 = entry.image.last?.label ?? ""
        collectionName = ""
    }
}

struct MusicAlbumWrapper: Codable {
    let resultCount: Int
    let results: [MusicAlbum]
}


struct ServerResponse: Decodable {
    var musicAlbums: [MusicAlbum]

    init(from decoder: Decoder) throws {
        let rawResponse = try RawServerResponse(from: decoder)
        musicAlbums = rawResponse.feed.entry.map { MusicAlbum(entry: $0) }
    }
}


fileprivate struct RawServerResponse: Decodable {
    var feed: Feed
}

fileprivate struct Feed: Decodable {
    var entry: [Entry]
}

fileprivate struct Entry: Decodable {
    var id: ID
    var category: FeedCategory
    var artist: Artist
    var image: [ImageURLs]
    
    fileprivate struct ID: Decodable {
        var attributes: ID_Attibutes
        fileprivate struct ID_Attibutes: Decodable {
            var id: String
            private enum CodingKeys: String, CodingKey {
                case id = "im:id"
            }
        }
    }
    
    fileprivate struct ImageURLs: Decodable {
        var label: String
    }
    
    fileprivate struct FeedCategory: Decodable {
        var attributes: Category_Attibutes
        fileprivate struct Category_Attibutes: Decodable {
            var label: String
        }
    }
    
    fileprivate struct Artist: Decodable {
        var label: String
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case category
        case artist = "im:artist"
        case image = "im:image"
    }
}



