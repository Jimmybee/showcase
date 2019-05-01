//
//  PostSelectionViewModelTests.swift
//  ShowcaseTests
//
//  Created by James Birtwell on 25/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import XCTest
import RxTest
import RxSwift
@testable import Showcase

class PostsModelSelectionViewModelTests: XCTestCase {
    
    var scheduler: TestScheduler!
    var bag: DisposeBag!
    var viewModel: PostsModelSelectionViewModel!

    let coreDataManager = CoreDataManager.shared
    let realmDataManager = RealmDataManager.shared
    let urlSessionProvider = UrlSessionProvider.shared
    
    override func setUp() {
        coreDataManager.saveContext()
        scheduler = TestScheduler(initialClock: 0)
        bag = DisposeBag()
        viewModel = PostsModelSelectionViewModel()
    }

    func testModelValidSegments() {
        let isMoyaValid = scheduler.createObserver(Bool.self)
        viewModel
            .enableMoya()
            .map({ $0.valid })
            .bind(to: isMoyaValid)
            .disposed(by: bag)
        
        scheduler.createColdObservable([.next(10, ViewBinding.rx),
                                        .next(20, ViewBinding.imperative)])
            .bind(to: viewModel.selectedViewBinding)
            .disposed(by: bag)
        
        scheduler.start()
        XCTAssertEqual(isMoyaValid.events, [
            .next(0, false),
            .next(10, true),
            .next(20, false)
            ])
    }
    
    func testIsCoreDataValid() {
        let isCoreDataValid = scheduler.createObserver(Bool.self)
        viewModel
            .enableCoreData()
            .map({ $0.valid })
            .bind(to: isCoreDataValid)
            .disposed(by: bag)
        scheduler.createColdObservable([.next(10, ViewBinding.rx),
                                        .next(20, ViewBinding.imperative)])
            .bind(to: viewModel.selectedViewBinding)
            .disposed(by: bag)
        scheduler.start()
        XCTAssertEqual(isCoreDataValid.events, [
            .next(0, true),
            .next(10, false),
            .next(20, true)
            ])
    }
    
    func testCreateImperativeWithRealmAndUrlSession() {
        viewModel.selectedViewBinding.value = .imperative
        viewModel.selectedPersistence.value = .realm
        viewModel.selectedNetwork.value = .urlSession
        XCTAssert(viewModel.handleOpenPostsTap() is PostsListViewController)
    }
    
    func testCreateImperativeWithCoreDataAndUrlSession() {
        viewModel.selectedViewBinding.value = .imperative
        viewModel.selectedPersistence.value = .coreData
        viewModel.selectedNetwork.value = .urlSession
        XCTAssert(viewModel.handleOpenPostsTap() is PostsListViewController)
    }
    
    func testNilImperativeWithRealmAndMoya() {
        viewModel.selectedViewBinding.value = .imperative
        viewModel.selectedPersistence.value = .realm
        viewModel.selectedNetwork.value = .moya
        XCTAssert(viewModel.handleOpenPostsTap() == nil)
    }
    
    func testNilImperativeWithCoreDataAndMoya() {
        viewModel.selectedViewBinding.value = .imperative
        viewModel.selectedPersistence.value = .coreData
        viewModel.selectedNetwork.value = .moya
        XCTAssert(viewModel.handleOpenPostsTap() == nil)
    }
    
    func testCreateRxWithRealmAndUrlSession() {
        viewModel.selectedViewBinding.value = .rx
        viewModel.selectedPersistence.value = .realm
        viewModel.selectedNetwork.value = .urlSession
        XCTAssert(viewModel.handleOpenPostsTap() is RxPostsListViewController)
    }
    
    func testNilRxWithCoreDataAndUrlSession() {
        viewModel.selectedViewBinding.value = .rx
        viewModel.selectedPersistence.value = .coreData
        viewModel.selectedNetwork.value = .urlSession
        XCTAssert(viewModel.handleOpenPostsTap() == nil)
    }
    
    func testCreateRxWithRealmAndMoya() {
        viewModel.selectedViewBinding.value = .rx
        viewModel.selectedPersistence.value = .realm
        viewModel.selectedNetwork.value = .moya
        XCTAssert(viewModel.handleOpenPostsTap() is RxPostsListViewController)
    }
    
    func testNilRxWithCoreDataAndMoya() {
        viewModel.selectedViewBinding.value = .rx
        viewModel.selectedPersistence.value = .coreData
        viewModel.selectedNetwork.value = .moya
        XCTAssert(viewModel.handleOpenPostsTap() == nil)
    }
    
}


