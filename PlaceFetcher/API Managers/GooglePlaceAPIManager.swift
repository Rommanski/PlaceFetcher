//
//  GooglePlaceAPIManager.swift
//  PlaceFetcher
//
//  Created by Dmytro Bohachevskyy on 8/8/17.
//  Copyright © 2017 Dmytro Bohachevskyy. All rights reserved.
//

import CoreLocation
import RxSwift

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

    func getLocations(for keyword: String, with coords: CLLocationCoordinate2D) -> Observable<GooglePlaceArrayResult> {
        return Observable<GooglePlaceArrayResult>.create({ (observer) -> Disposable in
            self.getLocations(for: keyword, with: coords, callback: { (result) in
                switch result {
                case .success(let val):
                    observer.onNext(val)

                case .failure(let err):
                    observer.onError(err)
                }
            })

            return Disposables.create()
        })
    }

}
