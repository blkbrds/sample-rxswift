//
//  LoginViewController.swift
//  RxSwift-Demo
//
//  Created by HaiPNT on 6/8/17.
//  Copyright © 2017 Asian Tech. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MVVM

class LoginViewController: BaseViewController, MVVM.View {

    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!

    var viewModel: LoginViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }

    func updateView() {
        setupModelView()
        setupObservable()
    }

    private func setupObservable() {
        viewModel.loginObservable.bind { user, error in
            // TODO: - add logic for login
            if let error = error {
                print(error.localizedDescription)
            } else {
                // call login
                print(user?.name ?? "")
            }
        }.addDisposableTo(disposeBag)

        viewModel.loginEnabled.bind { [weak self] valid in
            guard let this = self else { return }
            this.loginButton.isEnabled = valid
            this.loginButton.alpha = valid ? 1 : 0.5
        }.addDisposableTo(disposeBag)
    }

    private func setupModelView() {
        viewModel = LoginViewModel(input: (userName: usernameTextField.rx.text.orEmpty,
                                           pw: passwordTextField.rx.text.orEmpty,
                                           loginTap: loginButton.rx.tap.asObservable()))
    }
}
