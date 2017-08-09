//
//  GooglePlaceResult.swift
//  PlaceFetcher
//
//  Created by Dmytro Bohachevskyy on 8/8/17.
//  Copyright © 2017 Dmytro Bohachevskyy. All rights reserved.
//

import ObjectMapper

class GooglePlaceArrayResult: ResultArrayWrapper<GooglePlaceItem> {

    override func mapping(map: Map) {
        super.mapping(map: map)
        result          <- map["predictions"]
    }

}

class GooglePlaceObjectResult: ResultObjectWrapper<GooglePlaceItem> {

}
