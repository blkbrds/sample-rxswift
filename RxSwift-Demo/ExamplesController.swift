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
        case search = 2

        static var numberExamples: Int {
            return 1
        }

        var storyboard: String {
            switch self {
            case .calculator: return "Calculator"
            case .search: return "Search"
            }
        }
    }

    // TODO: examples implement
    var examples: [String] = ["Calculator", "Validation", "Search", "MVVM - Demo", "MVVM - GitHub Search Repos"]

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
        guard let demo = Demo(rawValue: indexPath.row) else { fatalError() }
        let storyboard = UIStoryboard(name: demo.storyboard, bundle: nil)
        switch demo {
        case .calculator:
            let controller: CalculatorController = storyboard.instantiateViewController()
            navigationController?.pushViewController(controller, animated: true)
        case .search:
            let controller: SearchController = storyboard.instantiateViewController()
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
