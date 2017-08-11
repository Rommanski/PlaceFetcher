//
//  PlaceFetcherTests.swift
//  PlaceFetcherTests
//
//  Created by Dmytro Bohachevskyy on 8/8/17.
//  Copyright © 2017 Dmytro Bohachevskyy. All rights reserved.
//

import XCTest
import Alamofire
import RxSwift
import GoogleMaps
@testable import PlaceFetcher

class PlaceFetcherTests: XCTestCase {
    var navigationController: UINavigationController!
    var controllerUnderTest: PlaceSearchController!
    let bag = DisposeBag()

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "Main",
                                      bundle: Bundle.main)
        navigationController = storyboard.instantiateViewController(withIdentifier: "navigationController") as? UINavigationController
        controllerUnderTest = navigationController?.topViewController as? PlaceSearchController
        controllerUnderTest.isTesting = true

        UIApplication.shared.keyWindow!.rootViewController = controllerUnderTest

        // The One Weird Trick!
        _ = navigationController?.view
        _ = controllerUnderTest.view
    }

    override func tearDown() {
        controllerUnderTest = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    private let centerLat = 37.7749073
    private let centerLng = -122.4193878

    func testExample() {
        GooglePlaceAPIManager.sharedInstance = GooglePlaceAPIManager(netwrokManager: AutocompleteManagerMock())
        controllerUnderTest.viewModel.searchTextVariable.value = "test"
        // we must have 3 autocomplete elements
        XCTAssert(controllerUnderTest.viewModel.searchResultVariable.value.count == 3)

        GooglePlaceAPIManager.sharedInstance = GooglePlaceAPIManager(netwrokManager: PlaceDetailsManagerMock())
        // click to the second row
        controllerUnderTest.tableView.delegate?.tableView?(controllerUnderTest.tableView, didSelectRowAt: IndexPath(row: 1, section: 0))
        // vc must be pushed
        XCTAssert(navigationController.viewControllers.last?.isKind(of: PlaceShowViewController.self) ?? false)

        if let placeShowVC = navigationController?.topViewController as? PlaceShowViewController {
            _ = placeShowVC.view
            // check center of the map view
            let region = GMSCoordinateBounds(region: placeShowVC.mapView.projection.visibleRegion())
            XCTAssert(region.contains(CLLocationCoordinate2D(latitude: centerLat, longitude: centerLng)))
        }
    }

}

fileprivate class AutocompleteManagerMock: BaseTestNetworkManager {
    override var mockFile: String {
        return "AutocomplteMock"
    }
}

fileprivate class PlaceDetailsManagerMock: BaseTestNetworkManager {
    override var mockFile: String {
        return "PlaceDetails"
    }
}
