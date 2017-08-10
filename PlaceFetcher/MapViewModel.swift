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
    let selectedPlaceVariable = Variable<GooglePlaceItem?>(nil)
    let selectedPlaceSubject = PublishSubject<Int>()

    let bag = DisposeBag()

    init() {
        searchTextVariable.asObservable()
            .map { val -> String in
                return val?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            }
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            // do not spam server :)
            .debounce(0.5, scheduler: MainScheduler.instance)
            .flatMap { (val) -> Observable<GooglePlaceArrayResult> in
                return GooglePlaceAPIManager.sharedInstance.getAutocomplete(for: val, with: self.searchCoordVariable.value)
            }
            .map { (arrayResult) -> [GooglePlaceItem] in
                return arrayResult.result
            }
            .asDriver(onErrorJustReturn: [])
            .drive(searchResultVariable)
            .addDisposableTo(bag)

        selectedPlaceSubject.asObservable()
            .flatMap { index -> Observable<GooglePlaceObjectResult> in
                return GooglePlaceAPIManager.sharedInstance.getDetails(forPlaceWithId: self.searchResultVariable.value[index].placeId)
            }
            .map { $0.object }
            .asDriver(onErrorDriveWith: Driver.never())
            .drive(selectedPlaceVariable)
            .addDisposableTo(bag)
    }

}
