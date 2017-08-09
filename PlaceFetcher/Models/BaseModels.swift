//
//  BaseModels.swift
//  PlaceFetcher
//
//  Created by Dmytro Bohachevskyy on 8/8/17.
//  Copyright © 2017 Dmytro Bohachevskyy. All rights reserved.
//

import ObjectMapper

protocol BaseResultProtocol: Mappable {
    var nextPageToken: String { get set }
    var status: String { get set }
}

protocol ObjectWrapperProtocol: BaseResultProtocol {
    associatedtype ItemType: Any
    var object: ItemType? { get set }
}

protocol ArrayWrapperProtocol: BaseResultProtocol {
    associatedtype ItemType: Any
    var result: [ItemType] { get set }
}

class ResultArrayWrapper<T: Mappable>: ArrayWrapperProtocol {
    typealias ItemType = T
    var result: [T] = []
    var nextPageToken: String = ""
    var status: String = ""

    // MARK: - object mapping

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        result          <- map["results"]
        nextPageToken   <- map["next_page_token"]
        status          <- map["status"]
    }
    
}

class ResultObjectWrapper<T: Mappable>: ObjectWrapperProtocol {
    typealias ItemType = T
    var object: T?
    var nextPageToken: String = ""
    var status: String = ""

    // MARK: - object mapping

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        object          <- map["results"]
        nextPageToken   <- map["next_page_token"]
        status          <- map["status"]
    }
    
}
