//
//  AlbumCollectionViewCell.swift
//  Showcase
//
//  Created by James Birtwell on 17/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    
    var album: MusicAlbum! {
        didSet {
            let route = iTunesRouter.image(url: album.artworkUrl100)
            NativeProvider.shared.imageRequest(type: route, handleSuccess: { (image) in
                DispatchQueue.main.async { [weak self] in
                    self?.albumArt.image = image
                }
            }) { (error) in
                error.log()
            }
        }
    }
    
    private let albumArt = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addSubview(albumArt)
        backgroundColor = UIColor(white: 1, alpha: 0.5)
        albumArt.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            albumArt.bottomAnchor.constraint(equalTo: bottomAnchor),
            albumArt.topAnchor.constraint(equalTo: topAnchor),
            albumArt.leadingAnchor.constraint(equalTo: leadingAnchor),
            albumArt.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
    }
    
}
