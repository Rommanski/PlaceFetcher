//
//  GooglePlaceAPIManager.swift
//  PlaceFetcher
//
//  Created by Dmytro Bohachevskyy on 8/8/17.
//  Copyright © 2017 Dmytro Bohachevskyy. All rights reserved.
//

import CoreLocation

class GooglePlaceAPIManager: BaseAPIManager<GooglePlaceObjectResult, GooglePlaceArrayResult> {
    static let sharedInstance = GooglePlaceAPIManager()

    // MARK: links
    private let locationUrl = "/maps/api/place/nearbysearch/json"

    func getLocations(for keyword: String, with coords: CLLocationCoordinate2D, callback: @escaping ((ApiResponse<GooglePlaceArrayResult>) -> Void)) {
        let params: [String: Any] = [
            "location": "\(coords.latitude),\(coords.longitude)",
            "keyword": keyword,
            "key": ApiKeys.googlePlaceApiKey,
            "radius": 500
        ]
        self.sendRequestWithArrayOfObjects(.get, url: locationUrl, params: params, callback: callback)
    }

}
