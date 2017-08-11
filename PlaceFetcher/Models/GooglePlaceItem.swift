//
//  GooglePlaceItem.swift
//  PlaceFetcher
//
//  Created by Dmytro Bohachevskyy on 8/8/17.
//  Copyright © 2017 Dmytro Bohachevskyy. All rights reserved.
//

import ObjectMapper
import CoreLocation

class GooglePlaceItem: Mappable {
    var name: String = ""
    var lat: Double = 0.0
    var lng: Double = 0.0

    // MARK: - object mapping

    required convenience public init?(map: Map) {
        self.init()
    }

    open func mapping(map: Map) {
        name    <- map["name"]
        lat     <- map["geometry.location.lat"]
        lng     <- map["geometry.location.lng"]
    }

    var coords: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }

}
