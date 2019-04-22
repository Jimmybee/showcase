//
//  PostsModelSelectionViewController.swift
//  Showcase
//
//  Created by James Birtwell on 22/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class PostsModelSelectionViewController: UIViewController {

    let bag = DisposeBag()
    @IBOutlet weak private var persistenceSegmentedControl: UISegmentedControl!
    @IBOutlet weak private var viewRefreshSegmentedControl: UISegmentedControl!
    @IBOutlet weak private var networkSegmentedControl: UISegmentedControl!
    @IBOutlet weak private var postsListBttn: UIButton!
    
    private let viewModel = PostSelectionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegments()
    }
    
    private func setupSegments() {
        persistenceSegmentedControl.setup(with: viewModel.persistenceOptions)
        viewRefreshSegmentedControl.setup(with: viewModel.viewBindingOptions)
        networkSegmentedControl.setup(with: viewModel.networkOptions)
        
        persistenceSegmentedControl.rx.selectedSegmentIndex
            .map{ Persistence(rawValue: $0) }.filterNil()
            .bind(to: viewModel.selectedPersistence)
            .disposed(by: bag)
        
        viewRefreshSegmentedControl.rx.selectedSegmentIndex
            .map{ ViewBinding(rawValue: $0) }.filterNil()
            .bind(to: viewModel.selectedViewBinding)
            .disposed(by: bag)
        
        networkSegmentedControl.rx.selectedSegmentIndex
            .map{ Network(rawValue: $0) }.filterNil()
            .bind(to: viewModel.selectedNetwork)
            .disposed(by: bag)
        
    }
    
    @IBAction private func handleOpenPostsList(_ sender: UIButton) {
        let provider: RxProvider = networkSegmentedControl.selectedSegmentIndex == 0 ? NativeProvider.shared : MoyaShowcaseProvider.shared
        let storageManager: PersistentDataManager = viewRefreshSegmentedControl.selectedSegmentIndex == 0 ? CoreDataManager.shared : RealmDataManager.shared
        let rxStorageManager: RxDataManager = RealmDataManager.shared
        let bvm = PostListViewModel(networkProvider: NativeProvider.shared, storageManager: storageManager)
        let rxvm = RxPostListViewModel(networkProvider: provider, storageManager: rxStorageManager)
        let vc = viewRefreshSegmentedControl.selectedSegmentIndex == 0 ?  PostsListViewController(viewModel: bvm) : RxPostsListViewController(viewModel: rxvm)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}




// URLSession = I & Rx
// Moya =  Rx
// Realm = I & Rx
// CoreData = I
