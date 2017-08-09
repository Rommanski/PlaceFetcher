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
        dropDown.anchorView = textFieldContainer
        dropDown.width = textFieldContainer.frame.width
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y: textFieldContainer.bounds.height + 20.0)
        dropDown.selectionAction = { [unowned self] (index: Int, _: String) in
            self.mapView.camera = GMSCameraPosition.camera(withTarget: self.viewModel.searchResultVariable.value[index].coords, zoom: 10.0)
        }

        searchingTextField.rx.text.asObservable().bind(to: viewModel.searchTextVariable).addDisposableTo(bag)
        viewModel.searchResultVariable.asObservable().subscribe(onNext: { [weak self] (placeItems) in
            self?.dropDown.dataSource = placeItems.map { $0.name }
            self?.dropDown.show()
        }).addDisposableTo(bag)
    }

}

class MapViewModel {
    let searchTextVariable = Variable<String?>("")
    let searchResultVariable = Variable<[GooglePlaceItem]>([])

    let bag = DisposeBag()

    init() {
        searchTextVariable.asObservable()
            // do not spam server :)
            .debounce(0.5, scheduler: MainScheduler.instance)
            .map { val -> String in
                return val ?? ""
            }
            .filter { !$0.isEmpty }
            .flatMap { (val) -> Observable<GooglePlaceArrayResult> in
            return GooglePlaceAPIManager.sharedInstance.getLocations(for: val, with: CLLocationCoordinate2D(latitude: -33.8670522, longitude: 151.1957362))
        }
            .map { (arrayResult) -> [GooglePlaceItem] in
            return arrayResult.result
        }
            .bind(to: searchResultVariable)
            .addDisposableTo(bag)
    }

}
