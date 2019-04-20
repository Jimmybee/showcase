//
//  iTunesRouter.swift
//  Showcase
//
//  Created by James Birtwell on 08/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation

// https://affiliate.itunes.apple.com/resources/documentation/itunes-store-web-service-search-api/
enum iTunesRouter {
    case search(query: ITunesSearchQuery)
    case genre(index: Int)
    case image(url: String)
}

extension iTunesRouter: NativeRouter {
    var requestUrl: URL {
        var urlString = baseURL
        if let urlParameters = urlParameters {
            urlString.append( urlParameters )
        }
        let url = URL(string: urlString)!
        return url
    }
    
    var baseURL: String {
        switch self {
    case .search:
        return "https://itunes.apple.com/search?"
    case .genre(let index):
        return "https://itunes.apple.com/us/rss/topalbums/genre=\(index)/json"
    case .image(url: let url):
        return url
        }
        
    }
    
    var path: String {
        return ""
    }
    
    var urlParameters: String? {
        switch self {
        case .search(query: let query):
            return query.dictionary?.queryString
        default:
            return nil
        }
    }
}


struct ITunesGenreTopAlbums: Codable {
    let media: ITunesMedia  = .music
    let attribute: Attribute = .genreIndex
    let limit: Int = 25
    let entity: Entity = .album
    let category = 2
    
    enum Entity: String, Codable {
        case musicArtist, musicTrack, album
    }
    
    enum Attribute: String, Codable {
        case artistTerm, songTerm, genreIndex
    }
}

enum ITunesMedia: String, Codable {
    case movie, podcast, music, musicVideo, audiobook, shortFilm, tvShow, software, ebook, all
}

