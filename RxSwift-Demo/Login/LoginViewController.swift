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

class LoginViewController: BaseViewController {

    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!

    var viewModel: LoginViewModel!

    private var usernameObservable: Observable<String> {
        return usernameTextField.rx.text.throttle(0.5, scheduler: MainScheduler.instance).map { text in
            guard let text = text else { return "" }
            return text
        }
    }

    private var passwordObservable: Observable<String> {
        return passwordTextField.rx.text.throttle(0.5, scheduler: MainScheduler.instance).map { text in
            guard let text = text else { return "" }
            return text
        }
    }

    private var loginButtonObservable: Observable<Void> {
        return loginButton.rx.tap.asObservable()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupModelView()
        setupObservable()
    }

    private func setupObservable() {
        viewModel.loginObservable.bind { user, error in
            // TODO: - add logic for login
            if let error = error {
                print(error.localizedDescription)
            } else {
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
        viewModel = LoginViewModel(input: (userName: usernameObservable,
                                           pw: passwordObservable,
                                           loginTap: loginButtonObservable) )
    }
}
