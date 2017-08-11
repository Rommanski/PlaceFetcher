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
import RxDataSources

class PlaceSearchController: UIViewController {
    enum Route: String {
        case placeOnMap
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchingTextField: UITextField!

    let viewModel = PlaceSearchViewModel()
    var router: SearchPlaceRouter!
    let bag = DisposeBag()
    var isTesting = false
    private let cellId = "placeCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.router = SearchPlaceRouter(viewModel: viewModel, testing: isTesting)
        self.title = "Search"

        // bind text field value to view model
        searchingTextField.rx.text.asObservable().bind(to: viewModel.searchTextVariable).addDisposableTo(bag)

        // display autocomplete result
        viewModel.searchResultVariable.asObservable()
            .map { result in
                return result.map { $0.placeDescription }
            }
            .bind(to: tableView.rx.items(cellIdentifier: cellId)) { _, model, cell in
                cell.textLabel?.text = model
            }
            .addDisposableTo(bag)

        // handle row selecting
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            self.viewModel.selectedPlace = self.viewModel.searchResultVariable.value[indexPath.row]
            self.router.route(to: Route.placeOnMap.rawValue, from: self, parameters: nil)
            self.view.endEditing(true)
        }).addDisposableTo(bag)
    }

}
