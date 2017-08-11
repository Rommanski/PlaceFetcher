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
    private let autocompleteUrl = "/maps/api/place/autocomplete/json"
    private let detailsUrl = "/maps/api/place/details/json"

    func getAutocomplete(for keyword: String, callback: @escaping ((ApiResponse<GooglePlaceArrayResult>) -> Void)) {
        let params: [String: Any] = [
            "input": keyword,
            "key": ApiKeys.googlePlaceApiKey
        ]
        self.sendRequestWithArrayOfObjects(.get, url: autocompleteUrl, params: params, callback: callback)
    }

    func getAutocomplete(for keyword: String) -> Observable<GooglePlaceArrayResult> {
        return Observable<GooglePlaceArrayResult>.create({ (observer) -> Disposable in
            self.getAutocomplete(for: keyword, callback: { (result) in
                self.openApiResponse(observer: observer, result: result)
            })

            return Disposables.create()
        })
    }

    func getDetails(forPlaceWithId placeId: String, callback: @escaping ((ApiResponse<GooglePlaceObjectResult>) -> Void)) {
        let params: [String: Any] = [
            "placeid": placeId,
            "key": ApiKeys.googlePlaceApiKey
        ]
        self.sendRequestWithSingelObject(.get, url: detailsUrl, params: params, callback: callback)
    }

    func getDetails(forPlaceWithId placeId: String) -> Observable<ApiResponse<GooglePlaceObjectResult>> {
        return Observable<ApiResponse<GooglePlaceObjectResult>>.create({ (observer) -> Disposable in
            self.getDetails(forPlaceWithId: placeId, callback: { (result) in
                observer.onNext(result)
            })

            return Disposables.create()
        })
    }

}
