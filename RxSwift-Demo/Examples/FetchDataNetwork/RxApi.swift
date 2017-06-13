//
//  rxApi.swift
//  RxSwift-Demo
//
//  Created by Huynh Quang Tien on 6/13/17.
//  Copyright © 2017 Asian Tech. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

typealias JObject = [String: Any]

final class RxApi {
    class func requestGet(url: URL, headers: [String: String]? = nil) -> Observable<([JObject])> {
        let response = Observable.from([url])
            .map { url -> URLRequest in
                var request = URLRequest(url: url)
                if let headers = headers {
                    for (key, value) in headers {
                        request.addValue(value, forHTTPHeaderField: key)
                    }
                }
                return request
            }
            .flatMap { request -> Observable<(HTTPURLResponse, Data)> in
                return URLSession.shared.rx.response(request: request)
            }
            .shareReplay(1)
            .filter { response, _ in
                return 200..<300 ~= response.statusCode
            }
            .map { _, data -> [JObject] in
                // save lastModified for next request
                // let lastModified = response.allHeaderFields["Last-Modified"] as? String
                // UserDefaults.standard.set(lastModified, forKey: "Last-Modified")

                guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                    let result = jsonObject as? [JObject] else {
                        return []
                }
                return result
            }
        return response
    }
}
