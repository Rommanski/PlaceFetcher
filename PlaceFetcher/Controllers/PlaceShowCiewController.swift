//
//  PlaceShowCiewController.swift
//  PlaceFetcher
//
//  Created by Dmytro Bohachevskyy on 8/10/17.
//  Copyright © 2017 Dmytro Bohachevskyy. All rights reserved.
//

import UIKit
import GoogleMaps
import RxSwift
import RxCocoa
import SVProgressHUD

class PlaceShowViewController: UIViewController {

    static func instantiate() -> PlaceShowViewController? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: self)) as? PlaceShowViewController
    }

    @IBOutlet weak var mapView: GMSMapView!

    var viewModel: PlaceShowViewModel!
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Look"

        // start loading animation
        SVProgressHUD.show()

        // subscribe to receiving info about place
        viewModel.placeForShowingObservable.subscribe(onNext: { [weak self] (result) in
            switch result {
            case .success(let place):
                SVProgressHUD.dismiss()
                if let coords = place.object?.coords {
                    self?.mapView.camera = GMSCameraPosition.camera(withTarget: coords, zoom: 10.0)
                }
                break

            case .failure(let err):
                SVProgressHUD.showError(withStatus: err.localizedDescription)
                break
            }

            }, onError: { (err) in
                SVProgressHUD.showError(withStatus: err.localizedDescription)
        }).addDisposableTo(bag)
    }

}
