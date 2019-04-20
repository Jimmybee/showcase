//
//  ITunesAlbumsViewModel.swift
//  Showcase
//
//  Created by James Birtwell on 15/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import RxSwift

class ITunesAlbumListViewModel {
    
    private var albums: [MusicAlbum]

    init(albums: [MusicAlbum]) {
        self.albums = albums
        print(albums)
    }
    
    var tableData: Observable<[MusicAlbum]> {
        return Observable.of(albums)
    }
}
