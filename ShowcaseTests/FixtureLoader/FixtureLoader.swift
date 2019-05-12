//
//  FixtureLoader.swift
//  RevRatesTests
//
//  Created by James Birtwell on 05/05/2019.
//  Copyright © 2019 BirtwellJ. All rights reserved.
//


import XCTest
@testable import Showcase

enum Fixture: String {
    case Post
    case User
}

class FixtureLoader {
    class func jsonData(from fixture: Fixture) throws -> Data {
        return try jsonData(from: fixture.rawValue)
    }

    class private func jsonData(from name: String) throws -> Data {
        guard let path = Bundle(for: self).path(forResource: name, ofType: "json") else {
            throw ClientError.unknownError("Fixture \(name) not found.")
        }
        let filePath = URL(fileURLWithPath: path)
        return try Data(contentsOf: filePath)
    }
}
