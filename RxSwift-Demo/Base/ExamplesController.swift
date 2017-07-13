//
//  ExamplesController.swift
//  RxSwift
//
//  Created by Huynh Quang Tien on 6/5/17.
//  Copyright © 2017 Asian Tech. All rights reserved.
//

import UIKit
import Photos

class ExamplesController: UITableViewController {

    enum Demo: Int {
        case calculator = 0
        case validateLogin
        case search
        case galleryImage
        case multipleCellTypes
        case mapView
        case customObservable
        case fetchDataNetwork
        case mvvmDemo
        case currencyExchange

        static let count = 10

        private var storyboard: String {
            switch self {
            case .calculator: return "Calculator"
            case .validateLogin: return "Login"
            case .search: return "Search"
            case .galleryImage: return "GalleryImage"
            case .multipleCellTypes: return "MultipleCellTypes"
            case .mapView: return "MapView"
            case .customObservable: return "CustomObservable"
            case .fetchDataNetwork: return "FetchDataNetwork"
            case .mvvmDemo: return "ListCar"
            case .currencyExchange: return "CurrencyExchange"
            }
        }

        var menuName: String {
            switch self {
            case .calculator: return "Calculator"
            case .validateLogin: return "Validate Login"
            case .search: return "Search"
            case .galleryImage: return "Gallery Image"
            case .multipleCellTypes: return "Multiple Cell Custom Types"
            case .customObservable: return "Custom Observable"
            case .fetchDataNetwork: return "Fetching Data From the Web"
            case .mvvmDemo: return "MVVM - Demo"
            case .currencyExchange: return "Currency Exchange"
            case .mapView: return "Map View"
            }
        }

        var controller: UIViewController {
            let storyboard = UIStoryboard(name: self.storyboard, bundle: nil)
            let controller = storyboard.instantiateViewController()
            return controller
        }
    }

    // TODO: examples implement
    lazy var examples: [Demo?] = { () -> [Demo?] in
        let demos = Array(0..<Demo.count).map({ (index) -> Demo? in
            return Demo(rawValue: index)
        })
        return demos
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        PHPhotoLibrary.requestAuthorization { _ in }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examples.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = examples[indexPath.row]?.menuName
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let demo = examples[indexPath.row] else { return }
        let controller = demo.controller
        navigationController?.pushViewController(controller, animated: true)
    }
}
