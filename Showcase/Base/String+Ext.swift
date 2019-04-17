//
//  String+Ext.swift
//  Showcase
//
//  Created by James Birtwell on 16/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation

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
