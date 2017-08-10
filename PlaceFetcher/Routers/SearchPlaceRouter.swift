//
//  SearchPlaceRouter.swift
//  PlaceFetcher
//
//  Created by Dmytro Bohachevskyy on 8/10/17.
//  Copyright © 2017 Dmytro Bohachevskyy. All rights reserved.
//

import UIKit

class SearchPlaceRouter: Router {
    unowned var viewModel: MapViewModel

    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
    }

    func route(to routeID: String, from context: UIViewController, parameters: Any?) {
        guard let route = MapViewController.Route(rawValue: routeID) else {
            return
        }

        switch route {
        case .placeOnMap:
            if let vc = PlaceShowViewController.instantiate(), let placeForShowing = viewModel.selectedPlace {
                vc.viewModel = PlaceShowViewModel(placeForLoading: placeForShowing)
                context.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

}
