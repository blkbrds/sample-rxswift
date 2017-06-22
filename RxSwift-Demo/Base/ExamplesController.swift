//
//  ExamplesController.swift
//  RxSwift
//
//  Created by Huynh Quang Tien on 6/5/17.
//  Copyright © 2017 Asian Tech. All rights reserved.
//

import UIKit

class ExamplesController: UITableViewController {

    enum Demo: Int {
        case calculator = 0
        case validate
        case search
        case MultipleCellTypes
        case fetchDataNetwork
        case mvvmDemo

        var storyboard: String {
            switch self {
            case .calculator: return "Calculator"
            case .validate: return "Login"
            case .search: return "Search"
            case .MultipleCellTypes: return "MultipleCellTypes"
            case .fetchDataNetwork: return "FetchDataNetwork"
            case .mvvmDemo: return "ListCar"
            }
        }
    }

    // TODO: examples implement
    var examples: [String] = ["Calculator", "Validation", "Search", "Multiple Cell Custom Types", "Fetching Data From the Web", "MVVM - Demo", "MVVM - GitHub Search Repos"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func controllerExampleFor(demo: Demo) -> UIViewController {
        let storyboard = UIStoryboard(name: demo.storyboard, bundle: nil)
        switch demo {
        case .calculator:
            let controller: CalculatorController = storyboard.instantiateViewController()
            return controller
        case .validate:
            let controller: LoginViewController = storyboard.instantiateViewController()
            return controller
        case .search:
            let controller: SearchController = storyboard.instantiateViewController()
            return controller
        case .MultipleCellTypes:
            let controller: MultipleCellTypesController = storyboard.instantiateViewController()
            return controller
        case .fetchDataNetwork:
            let controller: FetchDataNetworkController = storyboard.instantiateViewController()
            return controller
        case .mvvmDemo:
            let controller: CarController = storyboard.instantiateViewController()
            return controller
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examples.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = examples[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let demo = Demo(rawValue: indexPath.row) else { return }
        let controller = controllerExampleFor(demo: demo)
        navigationController?.pushViewController(controller, animated: true)
    }
}
