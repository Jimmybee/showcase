//
//  ITunesAlbumsViewController.swift
//  Showcase
//
//  Created by James Birtwell on 15/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ITunesAlbumListViewController: UIViewController  {
    
    let bag = DisposeBag()
    
    private let albumList: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 50, height: 50)
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.minimumLineSpacing = 1
        logD("albumList")
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return view
    }()
    
    private var guide: UILayoutGuide { return view.safeAreaLayoutGuide }
    private let viewModel: ITunesAlbumListViewModel
    
    init(viewModel: ITunesAlbumListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        constrianAlbumList()
        setupAlbumList()
        logD("viewDidLoad")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}

//MARK: Constraints
extension ITunesAlbumListViewController {
    func addViews() {
        view.addSubview(albumList)
    }
    
    func constrianAlbumList() {
        albumList.snp.makeConstraints{ $0.edges.equalToSuperview() }
    }
    
    func handle(error: Error) {
        guard let message = error.userAlertMessage else { return }
        let x = UIAlertController.present(in: self, title: "", message: message, style: .alert, actions: AlertButtons.actionsFor(buttons: AlertButtons.deleteAlert))
            .filter(<#T##predicate: (UIAlertController.AlertAction) throws -> Bool##(UIAlertController.AlertAction) throws -> Bool#>)
        
    }
}

//Setup
extension ITunesAlbumListViewController {
    func setupAlbumList() {
        albumList.backgroundColor = .orange
        albumList.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier())
        viewModel.tableData
            .bind(to: albumList.rx.items(cellIdentifier: AlbumCollectionViewCell.identifier(), cellType: AlbumCollectionViewCell.self)) { row, album, cell in
                cell.album = album
            }
            .disposed(by: bag)
    }
}

