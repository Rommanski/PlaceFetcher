//
//  ViewController.swift
//  PlaceFetcher
//
//  Created by Dmytro Bohachevskyy on 8/8/17.
//  Copyright © 2017 Dmytro Bohachevskyy. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import RxSwift
import RxCocoa
import DropDown

class MapController: UIViewController {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var searchingTextField: UITextField!
    @IBOutlet weak var textFieldContainer: UIView!

    let dropDown = DropDown()

    let viewModel = MapViewModel()
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.settings.myLocationButton = true
        mapView.rx.didUpdateLocation
            .map { $0.target }
            .bind(to: viewModel.searchCoordVariable)
            .addDisposableTo(bag)

        dropDown.anchorView = textFieldContainer
        dropDown.width = textFieldContainer.frame.width
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y: textFieldContainer.bounds.height + 20.0)
        dropDown.selectionAction = { [weak self] (index: Int, _: String) in
            self?.viewModel.selectedPlaceSubject.onNext(index)
        }

        searchingTextField.rx.text.asObservable().bind(to: viewModel.searchTextVariable).addDisposableTo(bag)
        viewModel.searchResultVariable.asObservable().subscribe(onNext: { [weak self] (placeItems) in
            self?.dropDown.dataSource = placeItems.map { $0.placeDescription }
            self?.dropDown.show()
        }).addDisposableTo(bag)

        viewModel.selectedPlaceVariable.asObservable().subscribe(onNext: { [weak self] (place) in
            if nil != place {
                self?.mapView.camera = GMSCameraPosition.camera(withTarget: place!.coords, zoom: 10.0)
            }
        }).addDisposableTo(bag)
    }

}

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
            .bind(to: searchResultVariable)
            .addDisposableTo(bag)

        selectedPlaceSubject.asObservable()
            .flatMap { index -> Observable<GooglePlaceObjectResult> in
                return GooglePlaceAPIManager.sharedInstance.getDetails(forPlaceWithId: self.searchResultVariable.value[index].placeId)
            }
            .map { $0.object }
            .bind(to: selectedPlaceVariable)
            .addDisposableTo(bag)
    }

}
