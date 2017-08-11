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
    var placeDescription: String = ""
    var placeId: String = ""
    var lat: Double = 0.0
    var lng: Double = 0.0
    var northeastLat: Double = 0.0
    var northeastLng: Double = 0.0
    var southwestLat: Double = 0.0
    var southwestLng: Double = 0.0

    // MARK: - object mapping

    required convenience public init?(map: Map) {
        self.init()
    }

    open func mapping(map: Map) {
        placeId             <- map["place_id"]
        name                <- map["name"]
        placeDescription    <- map["description"]
        name                <- map["name"]
        lat                 <- map["geometry.location.lat"]
        lng                 <- map["geometry.location.lng"]
        northeastLat        <- map["geometry.viewport.northeast.lat"]
        northeastLng        <- map["geometry.viewport.northeast.lng"]
        southwestLat        <- map["geometry.viewport.southwest.lat"]
        southwestLng        <- map["geometry.viewport.southwest.lng"]
    }

    var coords: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }

    var coordsNortheast: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: northeastLat, longitude: northeastLng)
    }

    var coordsSouthwest: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: southwestLat, longitude: southwestLng)
    }

}
