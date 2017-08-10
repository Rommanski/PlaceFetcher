//
//  RouterProtocol.swift
//  PlaceFetcher
//
//  Created by Dmytro Bohachevskyy on 8/10/17.
//  Copyright © 2017 Dmytro Bohachevskyy. All rights reserved.
//

import UIKit

protocol Router {

    func route(to routeID: String, from context: UIViewController, parameters: Any?)
    
}
