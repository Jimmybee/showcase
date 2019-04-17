//
//  ShowcaseTests.swift
//  ShowcaseTests
//
//  Created by James Birtwell on 06/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import XCTest
@testable import Showcase

class ShowcaseTests: XCTestCase {

    let cdm = CoreDataManager.shared

    override func setUp() {
        cdm.saveContext()
        cdm.delete(model: Post.self)
    }

    override func tearDown() {

    }

    func testCoreData() {
        do {
            let dictionary = try postJson.convertToDictionary()
            let data = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            let post = try JSONDecoder().decode(Post.self, from: data)
            let context = cdm.context
            PostCore.create(in: context, post: post)
            cdm.saveContext()

            guard let fetchedPosts: [Post] = cdm.getData() else { XCTFail(); return }
            XCTAssert(fetchedPosts.count == 1)
            
            let loadedPost = fetchedPosts.first!
            XCTAssert(loadedPost.id == 90)
            XCTAssert(loadedPost.title == "Test Post")
            XCTAssert(loadedPost.userId == 10)
            XCTAssert(loadedPost.body == "Locally created test post")
        } catch {
            print(error)
            XCTFail()
        }
        
      

    }

    func testPerformanceExample() {
        self.measure {
        }
    }

    let postJson: String = """
{           "userId": 10,
          "id": 90,
          "title": "Test Post",
          "body": "Locally created test post" }
"""
}


