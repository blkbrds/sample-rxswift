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

    var disposeBag = DisposeBag()

    @IBOutlet private var searchCityTextField: UITextField!
    @IBOutlet private var nameCityLabel: UILabel!
    @IBOutlet private var temperatureLabel: UILabel!
    @IBOutlet private var humidityLabel: UILabel!
    @IBOutlet private var iconLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        WeatherViewModel.shared.abc(city: "London")

        searchCityTextField.rx.text
        .filter { ($0 ?? "").isNotEmpty } // characters.count > 0
        .flatMap { text in
            return WeatherViewModel.shared.currentWeather(city: text ?? "Error")
        }
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] (data) in
            guard let this = self else { return }
            // Show data in here
            this.temperatureLabel.text = "\(data.temperature)° C"
            this.iconLabel.text = data.icon
            this.humidityLabel.text = "\(data.humidity)%"
            this.nameCityLabel.text = data.cityName
        })
        .addDisposableTo(disposeBag)
    }
}

extension String {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}
