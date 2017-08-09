//
//  GMSMapViewDelegate+Rx.swift
//  PlaceFetcher
//
//  Created by Dmytro Bohachevskyy on 8/10/17.
//  Copyright © 2017 Dmytro Bohachevskyy. All rights reserved.
//

import RxSwift
import RxCocoa
import GoogleMaps

//GMSMapViewDelegate

class RxGMSMapViewDelegateProxy: DelegateProxy, GMSMapViewDelegate, DelegateProxyType {

    class func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        (object as? GMSMapView)?.delegate = delegate as? GMSMapViewDelegate
    }

    class func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        return (object as? GMSMapView)?.delegate
    }

}

extension Reactive where Base: GMSMapView {
    var delegate: DelegateProxy {
        return RxGMSMapViewDelegateProxy.proxyForObject(base)
    }

    var didUpdateLocation: Observable<GMSCameraPosition> {
        return delegate.methodInvoked(#selector(GMSMapViewDelegate.mapView(_:idleAt:)))
        .map { parameters in
            return parameters[1] as? GMSCameraPosition ?? GMSCameraPosition()
        }
    }

}
