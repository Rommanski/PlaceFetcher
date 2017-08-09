//
//  ApiKeys.swift
//  PlaceFetcher
//
//  Created by Dmytro Bohachevskyy on 8/8/17.
//  Copyright © 2017 Dmytro Bohachevskyy. All rights reserved.
//

import Foundation

/**
 This struct contains all kays that are using in the app
 */
struct ApiKeys {
    static var googlePlaceApiKey = "AIzaSyBu5JMNPBSoipWh4nx2P4p3e8xU7kOj0U0"
    static var googleMapsApiKey = "AIzaSyD4hBfPLnD-fJVpt-IYEzVvQz49Mer6v4Q"

    // here we can handle case when there are production/testing server
    static var serverUrl: String {
        return "https://maps.googleapis.com"
    }

}
