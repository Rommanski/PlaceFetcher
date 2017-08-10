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
    enum Route: String {
        case placeOnMap
    }

    @IBOutlet private weak var searchingTextField: UITextField!
    private let dropDown = DropDown()

    let viewModel = MapViewModel()
    var router: SearchPlaceRouter!
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.router = SearchPlaceRouter(viewModel: viewModel)
        self.title = "Search"

        // setup drop down
        dropDown.anchorView = searchingTextField
        dropDown.width = searchingTextField.frame.width
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y: searchingTextField.bounds.height + 20.0)
        dropDown.selectionAction = { [unowned self] (index: Int, _: String) in
            self.viewModel.selectedPlace = self.viewModel.searchResultVariable.value[index]
            self.router.route(to: Route.placeOnMap.rawValue, from: self, parameters: nil)
            self.view.endEditing(true)
        }

        // bind text field value to view model
        searchingTextField.rx.text.asObservable().bind(to: viewModel.searchTextVariable).addDisposableTo(bag)

        // display result for user request
        viewModel.searchResultVariable.asObservable().subscribe(onNext: { [weak self] (placeItems) in
            // if this vc is last in navigation stack
            if self?.navigationController?.viewControllers.last?.isKind(of: MapViewController.self) ?? false {
                self?.dropDown.dataSource = placeItems.map { $0.placeDescription }
                self?.dropDown.show()
            }
        }).addDisposableTo(bag)

        // hide drop down when search field is empty
        searchingTextField.rx.text.asObservable()
            .map { $0?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "" }
            .filter { $0.isEmpty }
            .subscribe(onNext: { [weak self] _ in
                self?.dropDown.hide()
            }).addDisposableTo(bag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // deselect item in drop down and show view again
        dropDown.selectRow(at: nil)
        dropDown.show()
    }

}
