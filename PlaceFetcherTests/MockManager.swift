//
//  MockManager.swift
//  PlaceFetcher
//
//  Created by Dmytro Bohachevskyy on 8/11/17.
//  Copyright © 2017 Dmytro Bohachevskyy. All rights reserved.
//

import Foundation

class MockManager {

    static func getFileContent(withName name: String) -> String {
        // swiftlint:disable force_cast
        let testBundle = Bundle(for: MockManager.self)
        if let path = testBundle.path(forResource: name, ofType: "json") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                return data
            } catch {

            }
        }

        return ""
    }

}
