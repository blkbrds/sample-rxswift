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
        case fetchDataNetwork
        case mvvmDemo

        var storyboard: String {
            switch self {
            case .calculator: return "Calculator"
            case .validate: return "Login"
            case .search: return "Search"
            case .fetchDataNetwork: return "FetchDataNetwork"
            case .mvvmDemo: return "ListCar"
            }
        }
    }

    // TODO: examples implement
    var examples: [String] = ["Calculator", "Login", "Search", "Fetching Data From the Web", "MVVM - Demo", "MVVM - GitHub Search Repos"]

    override func viewDidLoad() {
        super.viewDidLoad()
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
        let storyboard = UIStoryboard(name: demo.storyboard, bundle: nil)
        switch demo {
        case .calculator:
            let controller: CalculatorController = storyboard.instantiateViewController()
            navigationController?.pushViewController(controller, animated: true)
        case .validate:
            let controller: LoginViewController = storyboard.instantiateViewController()
            navigationController?.pushViewController(controller, animated: true)
        case .search:
            let controller: SearchController = storyboard.instantiateViewController()
            navigationController?.pushViewController(controller, animated: true)
        case .fetchDataNetwork:
            let controller: FetchDataNetworkController = storyboard.instantiateViewController()
            navigationController?.pushViewController(controller, animated: true)
        case .mvvmDemo:
            let controller: CarController = storyboard.instantiateViewController()
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
