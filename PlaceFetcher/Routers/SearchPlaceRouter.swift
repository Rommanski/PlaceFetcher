//
//  SearchPlaceRouter.swift
//  PlaceFetcher
//
//  Created by Dmytro Bohachevskyy on 8/10/17.
//  Copyright © 2017 Dmytro Bohachevskyy. All rights reserved.
//

import UIKit

class SearchPlaceRouter: Router {
    unowned var viewModel: PlaceSearchViewModel
    var testing: Bool

    init(viewModel: PlaceSearchViewModel, testing: Bool) {
        self.viewModel = viewModel
        self.testing = testing
    }

    func route(to routeID: String, from context: UIViewController, parameters: Any?) {
        guard let route = PlaceSearchController.Route(rawValue: routeID) else {
            return
        }

        switch route {
        case .placeOnMap:
            if let vc = PlaceShowViewController.instantiate(), let placeForShowing = viewModel.selectedPlace {
                vc.viewModel = PlaceShowViewModel(placeForLoading: placeForShowing)
                context.navigationController?.pushViewController(vc, animated: !testing)
            }
        }
    }

}
