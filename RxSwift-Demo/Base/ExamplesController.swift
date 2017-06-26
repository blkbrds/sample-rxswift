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
        case MultipleCellTypes
        case CustomObservable
        case fetchDataNetwork
        case mvvmDemo
        case currencyExchange

        static let count = 9

        var storyboard: String {
            switch self {
            case .calculator: return "Calculator"
            case .validateLogin: return "Login"
            case .search: return "Search"
            case .galleryImage: return "GalleryImage"
            case .MultipleCellTypes: return "MultipleCellTypes"
            case .CustomObservable: return "CustomObservable"
            case .fetchDataNetwork: return "FetchDataNetwork"
            case .mvvmDemo: return "ListCar"
            case .currencyExchange: return "CurrencyExchange"
            }
        }

        var menuName: String {
            switch self {
            case .calculator: return "Calculator"
            case .validateLogin: return "Validation"
            case .search: return "Search"
            case .galleryImage: return "Gallery Image"
            case .MultipleCellTypes: return "Multiple Cell Custom Types"
            case .CustomObservable: return "Custom Observable"
            case .fetchDataNetwork: return "Fetching Data From the Web"
            case .mvvmDemo: return "MVVM - GitHub Search Repos"
            case .currencyExchange: return "Currency Exchange"
            }
        }

        var controller: UIViewController {
            let storyboard = UIStoryboard(name: self.storyboard, bundle: nil)
            switch self {
            case .calculator:
                let controller: CalculatorController = storyboard.instantiateViewController()
                return controller
            case .validateLogin:
                let controller: LoginViewController = storyboard.instantiateViewController()
                return controller
            case .search:
                let controller: SearchController = storyboard.instantiateViewController()
                return controller
            case .MultipleCellTypes:
                let controller: MultipleCellTypesController = storyboard.instantiateViewController()
                return controller
            case .galleryImage:
                let controller: GalleryImageViewController = storyboard.instantiateViewController()
                return controller
            case .fetchDataNetwork:
                let controller: FetchDataNetworkController = storyboard.instantiateViewController()
                return controller
            case .CustomObservable:
                let controller: CustomObservableController = storyboard.instantiateViewController()
                return controller
            case .mvvmDemo:
                let controller: CarController = storyboard.instantiateViewController()
                return controller
            case .currencyExchange:
                let controller: CurrencyExchangeVC = storyboard.instantiateViewController()
                return controller
            }
        }
    }

    // TODO: examples implement
    lazy var examples: [Demo?] = { () -> [Demo?] in
        let demos = Array(0..<Demo.count).map({ (index) -> Demo? in
            return Demo(rawValue: index)
        })
        return demos
    }()

    func controllerExampleFor(demo: Demo) -> UIViewController {
        return demo.controller
    }

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
