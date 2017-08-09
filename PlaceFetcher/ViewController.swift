//
//  ViewController.swift
//  PlaceFetcher
//
//  Created by Dmytro Bohachevskyy on 8/8/17.
//  Copyright © 2017 Dmytro Bohachevskyy. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        GooglePlaceAPIManager.sharedInstance.getLocations(for: "cruise", with: CLLocationCoordinate2D(latitude: -33.8670522, longitude: 151.1957362)) { (result) in

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
