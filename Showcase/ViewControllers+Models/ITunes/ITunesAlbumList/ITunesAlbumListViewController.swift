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
import RxOptional

class ITunesAlbumListViewController: UIViewController  {
    
    let bag = DisposeBag()
    let error = PublishSubject<Error>()
    
    private let albumList: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 50, height: 50)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
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
        setupNavigation()
        constrianAlbumList()
        setupAlbumList()
        logD("viewDidLoad")
        observeViewDidAppearOnce()
        albumList.backgroundColor = .blue
    }
    
    private func setupNavigation(){
        navigationItem.title = ITunesStrings.album_list.localized
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let doneBttn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
        doneBttn.tintColor = .white
        doneBttn.rx.tap
            .subscribe(onNext: { (_) in
            self.navigationController?.dismiss(animated: true, completion: nil)
        }).disposed(by: bag)
        navigationItem.leftBarButtonItem = doneBttn
    }

    private func observeViewDidAppearOnce() {
        rx.viewWillAppear
            .take(1)
            .subscribe(onNext: { [weak self] (_) in
                self?.setAlbumListLayout()
            })
            .disposed(by: bag)
    }
    
}

//MARK: Constraints
extension ITunesAlbumListViewController {
    func addViews() {
        view.addSubview(albumList)
    }
    
    func constrianAlbumList() {
        let guide = view.safeAreaInsets
        albumList.snp.makeConstraints{ $0.edges.equalTo(guide) }
    }
    
    func observeErrors() {
        error.asObservable()
            .map{ $0.userAlertMessage }
            .filterNil()
            .flatMap { (message) -> Observable<UIAlertController.AlertAction> in
                return  UIAlertController
                    .present(in: self, title: "", message: message, style: .alert, actions: Alerts.ok.actions)
            }
            .subscribe()
            .disposed(by: bag)
    }
}

//Setup
extension ITunesAlbumListViewController {
    private func setupAlbumList() {
        albumList.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier())
        viewModel.tableData
            .bind(to: albumList.rx.items(cellIdentifier: AlbumCollectionViewCell.identifier(), cellType: AlbumCollectionViewCell.self)) { row, album, cell in
                cell.album = album
            }
            .disposed(by: bag)
    }
    
    private func setAlbumListLayout() {
        let layout = (albumList.collectionViewLayout as! UICollectionViewFlowLayout)
        let halfWidth = view.bounds.width / 2
        layout.itemSize = CGSize(width: halfWidth, height: halfWidth)
    }
    
}

