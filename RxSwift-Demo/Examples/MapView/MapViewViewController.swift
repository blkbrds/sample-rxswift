//
//  MapViewViewController.swift
//  RxSwift-Demo
//
//  Created by Hieu Tran T. on 6/29/17.
//  Copyright © 2017 Asian Tech. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxMapKit
import MapKit

class MapViewViewController: BaseViewController {

    @IBOutlet private weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupObservable()
    }

    private func setupObservable() {
        // Camera position
        mapView.rx.regionDidChange.asDriver()
            .drive(onNext: { print("Did region change: \($0.region) isAnimated \($0.isAnimated)") })
            .addDisposableTo(disposeBag)

        // Marker tapped
//        mapView.rx.didTapMarker.asDriver()
//            .drive(onNext: { print("Did tap marker: \($0)") })
//            .addDisposableTo(disposeBag)

        // Update marker icon
        mapView.rx.didSelectAnnotationView.asDriver()
            .drive(onNext: { $0.image = #imageLiteral(resourceName: "marker_selected") })
            .addDisposableTo(disposeBag)

        mapView.rx.didDeselectAnnotationView.asDriver()
            .drive(onNext: { $0.image = #imageLiteral(resourceName: "marker_normal") })
            .addDisposableTo(disposeBag)
    }
}
