//
//  ApiController.swift
//  RxSwift-Demo
//
//  Created by Hieu Tran T. on 6/19/17.
//  Copyright © 2017 Asian Tech. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MVVM

private let apiKey = "2813ebb6b1f2ebe66047759df3f34c2d"

struct Weather {
    let cityName: String
    let temperature: Int
    let humidity: Int
    let icon: String
}

class WeatherViewModel {

    static let shared = WeatherViewModel()

    func currentWeather(city: String) -> Observable<Weather> {
        // Placeholder call
        return Observable.just(
            Weather(
                cityName: city,
                temperature: 20,
                humidity: 90,
                icon: ""//iconNameToChar(icon: "01d")
            )
        )
    }
}
