//
//  WeatherViewController.swift
//  RxSwift-Demo
//
//  Created by Hieu Tran T. on 6/16/17.
//  Copyright © 2017 Asian Tech. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MVVM

class WeatherViewController: UIViewController {

    var viewModel: WeatherViewModel!
    var disposeBag = DisposeBag()

    @IBOutlet private var searchCityTextField: UITextField!
    @IBOutlet private var nameCityLabel: UILabel!
    @IBOutlet private var temperatureLabel: UILabel!
    @IBOutlet private var humidityLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        searchCityTextField.rx.ta

        viewModel.currentWeather(city: "yeah")
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] data in
            guard let this = self else { return }
            print(this)
            print(data)
        })
        .addDisposableTo(disposeBag)
    }
}
