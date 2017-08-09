//
//  BaseApiManager.swift
//  PlaceFetcher
//
//  Created by Dmytro Bohachevskyy on 8/8/17.
//  Copyright © 2017 Dmytro Bohachevskyy. All rights reserved.
//

import Alamofire
import ObjectMapper

typealias ApiResponse = Alamofire.Result

class BaseAPIManager<TObj: ObjectWrapperProtocol, TArr: ArrayWrapperProtocol> {
    private let netwrokManager: NetworkManagerProtocol

    required init(netwrokManager: NetworkManagerProtocol = NetworkManager.sharedInstance) {
        self.netwrokManager = netwrokManager
    }

    func sendRequestWithSingelObject(_ method: Alamofire.HTTPMethod = .get, url: String, params: [String: Any] = [:], customErrorHandle: Bool = false, callback: ((ApiResponse<TObj>) -> Void)?) {
        NetworkManager.sharedInstance.sendRequest(method, url: url, params: params) { (response) in
            switch response {
            case .failure(let err):
                callback?(ApiResponse.failure(err))
                break

            case .success(let jsonString):
                if let wrapper = Mapper<TObj>().map(JSONString: jsonString) {
                    callback?(ApiResponse.success(wrapper))
                }
                break
            }
        }
    }

    func sendRequestWithArrayOfObjects(_ method: Alamofire.HTTPMethod = .get, url: String, params: [String: Any] = [:], callback: ((ApiResponse<TArr>) -> Void)?) {
        NetworkManager.sharedInstance.sendRequest(method, url: url, params: params) { (response) in
            switch response {
            case .failure(let err):
                callback?(ApiResponse.failure(err))
                break

            case .success(let jsonString):
                if let wrapper = Mapper<TArr>().map(JSONString: jsonString) {
                    callback?(ApiResponse.success(wrapper))
                }
                break
            }
        }
    }

}
