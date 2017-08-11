//
//  BaseTestNetworkManager.swift
//  PlaceFetcher
//
//  Created by Dmytro Bohachevskyy on 8/11/17.
//  Copyright © 2017 Dmytro Bohachevskyy. All rights reserved.
//

import Foundation
import Alamofire
@testable import PlaceFetcher

class BaseTestNetworkManager: NetworkManagerProtocol {

    var mockFile: String {
        return ""
    }

    func get(_ url: String, params: [String: Any] = [:], callback: ((StringApiResponse) -> Void)?) {

    }

    func post(_ url: String, params: [String: Any] = [:], callback: ((StringApiResponse) -> Void)?) {

    }

    func put(_ url: String, params: [String: Any] = [:], callback: ((StringApiResponse) -> Void)?) {

    }

    func patch(_ url: String, params: [String: Any] = [:], callback: ((StringApiResponse) -> Void)?) {

    }

    func delete(_ url: String, params: [String: Any] = [:], callback: ((StringApiResponse) -> Void)?) {

    }

    func sendRequest(_ method: Alamofire.HTTPMethod, url: String, params: [String: Any], callback: ((StringApiResponse) -> Void)?) {
        let content = MockManager.getFileContent(withName: mockFile)
        callback?(StringApiResponse.success(content))
    }

}
