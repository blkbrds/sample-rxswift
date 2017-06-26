//
//  CurrencyExchangeVC.swift
//  RxSwift-Demo
//
//  Created by HaiPNT on 6/26/17.
//  Copyright © 2017 Asian Tech. All rights reserved.
//

import UIKit
import MVVM
import RxAlamofire

let sourceStringURL = "http://api.fixer.io/latest?base=EUR&symbols=USD"

class CurrencyExchangeVC: BaseViewController, MVVM.View {

    @IBOutlet private weak var fromTextField: UITextField!
    @IBOutlet private weak var toTextField: UITextField!
    @IBOutlet private weak var convertBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
    }

    @IBAction func convertBtnTap (_ sender: UIButton) {
        fromTextField.resignFirstResponder()

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        if let fromValue = NumberFormatter().number(from: self.fromTextField.text ?? "")?.floatValue {
            RxAlamofire.requestJSON(.get, sourceStringURL).debug().subscribe(
                onNext: { [weak self] (_, json) in
                    guard let this = self else { return }

                    if let dict = json as? [String: AnyObject], let valDict = dict["rates"] as? [String: AnyObject] {
                        if let conversionRate = valDict["USD"] as? Float {
                            this.toTextField.text = formatter
                                .string(from: NSNumber(value: conversionRate * fromValue))
                        }
                    }
                }, onError: { [weak self] (error) in
                    guard let this = self else { return }
                    this.displayError(error as NSError)
                })
                .addDisposableTo(disposeBag)
        } else {
            self.toTextField.text = "Invalid Input!"
        }
    }

    func displayError(_ error: NSError?) {
        if let e = error {
            let alertController = UIAlertController(title: "Error", message: e.localizedDescription, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                // do nothing...
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
