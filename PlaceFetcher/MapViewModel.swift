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

class MapViewModel {
    let searchTextVariable = Variable<String?>("")
    let searchCoordVariable = Variable<CLLocationCoordinate2D>(CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
    let searchResultVariable = Variable<[GooglePlaceItem]>([])
    var selectedPlace: GooglePlaceItem?

    let bag = DisposeBag()
    private let debounceTime = 0.3

    init() {
        searchTextVariable.asObservable()
            .map { val -> String in
                return val?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            }
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            // do not spam server :)
            .debounce(debounceTime, scheduler: MainScheduler.instance)
            .flatMap { (val) -> Observable<GooglePlaceArrayResult> in
                return GooglePlaceAPIManager.sharedInstance.getAutocomplete(for: val, with: self.searchCoordVariable.value)
            }
            .map { (arrayResult) -> [GooglePlaceItem] in
                return arrayResult.result
            }
            // just do not show any autocomplete in case any error
            .asDriver(onErrorJustReturn: [])
            .drive(searchResultVariable)
            .addDisposableTo(bag)
    }

}
