//
//  iTunesRouter.swift
//  Showcase
//
//  Created by James Birtwell on 08/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import Moya

// https://affiliate.itunes.apple.com/resources/documentation/itunes-store-web-service-search-api/
enum iTunesRouter {
    case search(query: ITunesSearchQuery)
    case genre(index: Int)
}

typealias DualRouter = NativeRouter & TargetType
extension iTunesRouter: TargetType {
    
    var headers: [String : String]? {
        return nil
    }
    
    var baseURL: URL { return URL(string: "https://itunes.apple.com/")! }
    
    var method: Moya.Method {
        return .get
    }

    var path: String {
        switch self {
        case .search:
            return "search"
        case .genre(let index):
            return "us/rss/topalbums/genre=\(index)/json"
        }
    }
    
    var task: Task {
        switch self {
        case .search(query: let query):
            guard let dict = query.dictionary else { return .requestPlain }
            return .requestParameters(parameters: dict, encoding: URLEncoding.queryString)
        case .genre:
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        return "{{\"Implemented\": \"Nope\"}}".data(using: .utf8)!
    }
}

extension iTunesRouter: NativeRouter {
    var nativeRequestUrl: URL {
        var urlString = baseURLstr
        if let urlParameters = urlParameters {
            urlString.append( urlParameters )
        }
        let url = URL(string: urlString)!
        return url
    }
    
    
    var baseURLstr: String {
        switch self {
        case .search:
            return "https://itunes.apple.com/search?"
        case .genre(let index):
            return "https://itunes.apple.com/us/rss/topalbums/genre=\(index)/json"
        }
        
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

