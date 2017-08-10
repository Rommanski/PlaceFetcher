//
//  PlaceShowViewModel.swift
//  PlaceFetcher
//
//  Created by Dmytro Bohachevskyy on 8/10/17.
//  Copyright © 2017 Dmytro Bohachevskyy. All rights reserved.
//

import RxSwift

class PlaceShowViewModel {
    var placeForShowingObservable: Observable<ApiResponse<GooglePlaceObjectResult>>

    init(placeForLoading place: GooglePlaceItem) {
        placeForShowingObservable = GooglePlaceAPIManager.sharedInstance.getDetails(forPlaceWithId: place.placeId).shareReplay(1) // keep last value
    }

}
