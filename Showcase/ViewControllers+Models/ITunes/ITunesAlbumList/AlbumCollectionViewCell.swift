//
//  AlbumCollectionViewCell.swift
//  Showcase
//
//  Created by James Birtwell on 17/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import UIKit
import Kingfisher

class AlbumCollectionViewCell: UICollectionViewCell {
    
    var album: MusicAlbum! {
        didSet {
            let url = URL(string: album.artworkUrl100)
            albumArt.kf.setImage(
                with: url,
                placeholder: UIImage(named: "placeholderImage"),
                options: [
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
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
