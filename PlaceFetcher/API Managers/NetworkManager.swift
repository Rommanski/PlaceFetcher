//
//  NetworkManager.swift
//  PlaceFetcher
//
//  Created by Dmytro Bohachevskyy on 8/8/17.
//  Copyright © 2017 Dmytro Bohachevskyy. All rights reserved.
//

import Alamofire

typealias StringApiResponse = Alamofire.Result<String>

protocol NetworkManagerProtocol: class {

    func sendRequest(_ method: Alamofire.HTTPMethod, url: String, params: [String: Any], encoding: ParameterEncoding, callback: ((StringApiResponse) -> Void)?)

    func get(_ url: String, params: [String: Any], callback: ((StringApiResponse) -> Void)?)

    func post(_ url: String, params: [String: Any], callback: ((StringApiResponse) -> Void)?)

    func put(_ url: String, params: [String: Any], callback: ((StringApiResponse) -> Void)?)

    func patch(_ url: String, params: [String: Any], callback: ((StringApiResponse) -> Void)?)

    func delete(_ url: String, params: [String: Any], callback: ((StringApiResponse) -> Void)?)

}

class NetworkManager: NetworkManagerProtocol {
    static let sharedInstance = NetworkManager()

    // provide default headers for request
    fileprivate var defaultHeaders: [String: String] {
        return baseHeaders
    }

    fileprivate var baseHeaders: [String: String] {
        return [
            "Content-Type": "application/json"
        ]
    }

    let manager: Alamofire.SessionManager = {
        let memoryCapacity = 10 * 1024 * 1024 // 10mb memory cache
        let diskCapacity = 30 * 1024 * 1024 // 30mb disk cache
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: nil)
        return Alamofire.SessionManager(configuration: configuration)
    }()

    func get(_ url: String, params: [String: Any] = [:], callback: ((StringApiResponse) -> Void)?) {
        self.sendRequest(HTTPMethod.get, url: url, params: params, callback: callback)
    }

    func post(_ url: String, params: [String: Any] = [:], callback: ((StringApiResponse) -> Void)?) {
        self.sendRequest(HTTPMethod.post, url: url, params: params, callback: callback)
    }

    func put(_ url: String, params: [String: Any] = [:], callback: ((StringApiResponse) -> Void)?) {
        self.sendRequest(HTTPMethod.put, url: url, params: params, callback: callback)
    }

    func patch(_ url: String, params: [String: Any] = [:], callback: ((StringApiResponse) -> Void)?) {
        self.sendRequest(HTTPMethod.patch, url: url, params: params, callback: callback)
    }

    func delete(_ url: String, params: [String: Any] = [:], callback: ((StringApiResponse) -> Void)?) {
        self.sendRequest(HTTPMethod.delete, url: url, params: params, callback: callback)
    }

    func sendRequest(_ method: Alamofire.HTTPMethod, url: String, params: [String: Any] = [:], encoding: ParameterEncoding = URLEncoding.default, callback: ((StringApiResponse) -> Void)?) {
        let requestUrl = URL(string: ApiKeys.serverUrl + url)!

        let finalEncoding: ParameterEncoding = .get == method ? URLEncoding.queryString: JSONEncoding.default
        let request = manager.request(requestUrl, method: method, parameters: params, encoding: finalEncoding, headers: defaultHeaders)
        self.handleRequest(request, callback: callback)
    }

    fileprivate func handleRequest( _ request: DataRequest, callback: ((StringApiResponse) -> Void)? ) {
        request.responseString { (result) in
            if let resultError = result.error {
                callback?(StringApiResponse.failure(resultError))
                return
            }

            if result.result.isSuccess, let jsonString = result.result.value {
                callback?(StringApiResponse.success(jsonString))
            } else {
                //                callback?(nil, getErrorFor(SalonErrorType.invalidAPIResponse))
            }
        }
    }

}
