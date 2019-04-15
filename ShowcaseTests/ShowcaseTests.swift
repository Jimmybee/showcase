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

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let cdm = CoreDataManager.shared
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let cdm = CoreDataManager.shared

        do {
            let dictionary = try postJson.convertToDictionary()
            let data = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            let post = try JSONDecoder().decode(Post.self, from: data)
            let context = cdm.context
            PostCore.create(in: context, post: post)
            cdm.saveContext()

            guard let fetchedPosts: [PostCore] = cdm.getData() else { XCTFail(); return }
            XCTAssert(fetchedPosts.count == 1)
            
            let postCore = fetchedPosts.first!
            let loadedPost = Post(model: postCore)
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
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    let postJson: String = """
{           "userId": 10,
          "id": 90,
          "title": "Test Post",
          "body": "Locally created test post" }
"""
}


extension String {
    func convertToDictionary() throws ->  [String:AnyObject] {
        guard let data = self.data(using: .utf8) else {
            throw ClientError.decodeFail("")
        }
        do {
            let object = try JSONSerialization.jsonObject(with: data, options: [])
            guard let dict = object as? [String:AnyObject] else {
                 throw ClientError.decodeFail("")
            }
            return dict
        } catch let error as NSError {
            throw error
        }
    }
}
