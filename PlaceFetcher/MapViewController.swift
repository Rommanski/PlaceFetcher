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

class MapViewController: UIViewController {
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
            self?.view.endEditing(true)
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
