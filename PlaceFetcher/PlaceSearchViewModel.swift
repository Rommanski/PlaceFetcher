//
//  MapViewModel.swift
//  PlaceFetcher
//
//  Created by Dmytro Bohachevskyy on 8/10/17.
//  Copyright © 2017 Dmytro Bohachevskyy. All rights reserved.
//

import RxSwift
import RxCocoa
import CoreLocation

class PlaceSearchViewModel {
    let searchTextVariable = Variable<String?>("")
    let searchCoordVariable = Variable<CLLocationCoordinate2D>(CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
    let searchResultVariable = Variable<[GooglePlaceItem]>([])
    var selectedPlace: GooglePlaceItem?

    let bag = DisposeBag()
    var debounceTime = 0.3
    var myDefaultScheduler: SchedulerType = MainScheduler.instance

    init() {
        let searchTextObservable = searchTextVariable.asObservable()
            .map { val -> String in
                return val?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            }
            .distinctUntilChanged()

        // request autocomplete if serch test is not empty
        searchTextObservable
            .filter { !$0.isEmpty }
            .flatMap { (val) -> Observable<GooglePlaceArrayResult> in
                return GooglePlaceAPIManager.sharedInstance.getAutocomplete(for: val)
            }
            .map { (arrayResult) -> [GooglePlaceItem] in
                return arrayResult.result
            }
            // just do not show any autocomplete in case any error
            .asDriver(onErrorJustReturn: [])
            .drive(searchResultVariable)
            .addDisposableTo(bag)

        // nothing to display if serach text is empty
        searchTextObservable
            .filter { $0.isEmpty }
            .map { _ in return [] }
            .bind(to: searchResultVariable)
            .addDisposableTo(bag)
    }

}
