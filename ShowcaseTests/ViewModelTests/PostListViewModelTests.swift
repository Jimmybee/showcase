//
//  PostListViewModelTests.swift
//  ShowcaseTests
//
//  Created by James Birtwell on 12/05/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import XCTest
import RxTest
import RxSwift
import RxBlocking
@testable import Showcase

class PostListViewModelTests: XCTestCase {

    var bag: DisposeBag!
    var scheduler: TestScheduler!
    
    var dataManager: TestDataManager!
    var networkProvider: TestNetworkProvider!
    var sut: RxPostListViewModel!
    
    override func setUp() {
        dataManager = TestDataManager()
        bag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
        networkProvider = TestNetworkProvider()
        networkProvider.scheduler = scheduler
        sut = RxPostListViewModel(networkProvider: networkProvider, storageManager: dataManager)

    }
    
    func testLoadingObserver() {
        let networkResultEnd = 10
        networkProvider.schedulerTime = networkResultEnd
        let sutLoading = sut.loadingObserver
        let sutObserver = scheduler.createObserver(Bool.self)
        sutLoading.bind(to: sutObserver).disposed(by: bag)
        
        sut.refreshData()
        
        scheduler.start()
        XCTAssertEqual(sutObserver.events, [
            .next(0, true),
            .next(0, true),
            .next(networkResultEnd, false)
            ])
    }
    
    func testTableData() throws {
        let post = try Post.Fixture.getSingle()
        let user = try User.Fixture.getSingle()
        
        let postKey = String(describing: Post.self)
        let postSchedule = scheduler.createColdObservable([.next(0, ([])),
                                                           .next(5, ([post]))])
        let userKey = String(describing: User.self)
        let userSchedule = scheduler.createColdObservable([.next(0, ([])),
                                                           .next(10, ([user]))])
        dataManager.schedulerObservables[postKey] = postSchedule
        dataManager.schedulerObservables[userKey] = userSchedule
        
        sut = RxPostListViewModel(networkProvider: networkProvider, storageManager: dataManager)
        let sutTableSectionCount = sut.tablePosts.map({ $0.count })
        let sutTableFirstSectionItemCount = sut.tablePosts.map{ $0.first?.items.count }.filterNil()
        
        let sectionCountObserver = scheduler.createObserver(Int.self)
        let sectionItemCountObserver = scheduler.createObserver(Int.self)

        sutTableSectionCount.bind(to: sectionCountObserver).disposed(by: bag)
        sutTableFirstSectionItemCount.bind(to: sectionItemCountObserver).disposed(by: bag)
        
        scheduler.start()
        XCTAssertEqual(sectionCountObserver.events, [
            .next(0, 0),
            .next(5, 0),
            .next(10, 1)
            ])
        
        XCTAssertEqual(sectionItemCountObserver.events, [
            .next(10, 1)
            ])
    }
    
    func testGroupingByUser() {
        
    }
    
    
}

extension Post {
    struct Fixture {
        static func getSingle() throws -> Post  {
            let data = try FixtureLoader.jsonData(from: .Post)
            return try JSONDecoder().decode(Post.self, from: data)
        }
    }
}

extension User {
    struct Fixture {
        static func getSingle() throws -> User  {
            let data = try FixtureLoader.jsonData(from: .User)
            return try JSONDecoder().decode(User.self, from: data)
        }
    }
}