//
//  WeatherViewModel.swift
//  RxSwift-Demo
//
//  Created by Hieu Tran T. on 6/16/17.
//  Copyright © 2017 Asian Tech. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MVVM
import SwiftyJSON
import Alamofire

private let apiKey = "2813ebb6b1f2ebe66047759df3f34c2d"
private let endpoint = "http://api.openweathermap.org/data/2.5/weather"
typealias JSObject = [String: Any]

// http://api.openweathermap.org/data/2.5/weather?q=London&appid=2813ebb6b1f2ebe66047759df3f34c2d

class WeatherViewModel {

    static let shared = WeatherViewModel()

    struct Weather {
        let cityName: String
        let temperature: Int
        let humidity: Int
        let icon: String
    }

    func currentWeather(city: String) -> Observable<Weather> {
        // Placeholder call

        return Observable.just(
            Weather(
                cityName: city,
                temperature: 20,
                humidity: 90,
                icon: "icon name"//iconNameToChar(icon: "01d")
            )
        )
        //        return buildRequest(pathComponent: "weather", params: [("q", city)])
        //            .map { json in
        //                return Weather(
        //                    cityName: json["name"].string ?? "Unknown",
        //                    temperature: json["main"]["temp"].int ?? -1000,
        //                    humidity: json["main"]["humidity"].int  ?? 0,
        //                    icon: iconNameToChar(icon: json["weather"][0]["icon"].string ??
        //                        "e")
        //                ) }
    }

    func buildRequest() -> Observable<JSON>? {
        // Set up the URL
        guard let url = URL(string: endpoint) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        // make the request
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            // do stuff with response, data & error here
            print(error)
            print(response)
        })
        task.resume()

        return session.rx.data(request: request).map { JSON(data: $0) }
    }

    func abc(city: String) {
        let url: URLConvertible = endpoint// + "?q=" + city + "&appid=" + apiKey
        let info: JSObject = ["q": city, "appid": apiKey]
        Alamofire.request(url, method: .get, parameters: info, encoding: JSONEncoding.default, headers: nil).response { [weak self](result) in
            guard let this = self else { return }
            print(result.data)
            print(result)
        }
    }
}
