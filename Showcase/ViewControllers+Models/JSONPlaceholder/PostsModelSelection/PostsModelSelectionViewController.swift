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
    
    @IBOutlet weak private var postsListBttn: UIButton!
    @IBOutlet weak private var verticalStack: UIStackView!
    private var persistenceSegmentedControl: SegmentedControl<Persistence>!
    private var viewRefreshSegmentedControl: SegmentedControl<ViewBinding>!
    private var networkSegmentedControl: SegmentedControl<Network>!

    private let viewModel = PostsModelSelectionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegments()
        observeDisabledSegments()
    }
    
    private func setupSegments() {
        persistenceSegmentedControl = SegmentedControl(segments: viewModel.persistenceOptions)
        viewRefreshSegmentedControl = SegmentedControl(segments: viewModel.viewBindingOptions)
        networkSegmentedControl = SegmentedControl(segments: viewModel.networkOptions)
        verticalStack.insertArrangedSubview(viewRefreshSegmentedControl, at: 1)
        verticalStack.insertArrangedSubview(persistenceSegmentedControl, at: 3)
        verticalStack.insertArrangedSubview(networkSegmentedControl, at: 5)

        persistenceSegmentedControl.selectionVar.asObservable()
            .filterNil()
            .bind(to: viewModel.selectedPersistence)
            .disposed(by: bag)
        
        viewRefreshSegmentedControl.selectionVar.asObservable()
            .filterNil()
            .bind(to: viewModel.selectedViewBinding)
            .disposed(by: bag)
        
        networkSegmentedControl.selectionVar.asObservable()
            .filterNil()
            .bind(to: viewModel.selectedNetwork)
            .disposed(by: bag)
        
    }
    
    private func observeDisabledSegments() {
        viewModel.enableCoreData().subscribe(onNext: { [weak self] segmentValid in
            self?.persistenceSegmentedControl.set(segmentValid: segmentValid)
        }).disposed(by: bag)
        
        viewModel.enableMoya().subscribe(onNext: { [weak self] (segmentValid) in
            self?.networkSegmentedControl.set(segmentValid: segmentValid)
        }).disposed(by: bag)
    }
    
    @IBAction private func handleOpenPostsList(_ sender: UIButton) {
        guard let vc = viewModel.handleOpenPostsTap() else {
            let error = ClientError.unknownError("Failed to create view")
            error.log()
            return
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
