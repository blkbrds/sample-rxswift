//
//  LoginViewModel.swift
//  RxSwift-Demo
//
//  Created by HaiPNT on 6/8/17.
//  Copyright © 2017 Asian Tech. All rights reserved.
//

import Foundation
import MVVM
import RxSwift

class User {
    var name: String = ""
    var password: String?

    init(name: String, password: String? = nil) {
        self.name = name
        self.password = password
    }
}

private struct Validation {
    static let minimumPasswordLength = 4
    static let minimumUserNameLength = 5
}

class LoginViewModel: MVVM.ViewModel {

    typealias LoginViewModelParams = (userName: Observable<String>, pw: Observable<String>, loginTap: Observable<Void>)

    let validatedEmail: Observable<Bool>
    let validatedPassword: Observable<Bool>
    let loginEnabled: Observable<Bool>
    let loginObservable: Observable<(User?, Error?)>

    init(input: LoginViewModelParams) {

        validatedEmail = input.userName
            .map { $0.characters.count >= Validation.minimumUserNameLength }
            .shareReplay(1)

        validatedPassword = input.pw
            .map { $0.characters.count >= Validation.minimumPasswordLength }
            .shareReplay(1)

        loginEnabled = Observable.combineLatest(validatedEmail, validatedPassword) { $0 && $1 }

        let userAndPassword = Observable.combineLatest(input.userName, input.pw) { ($0, $1) }

        loginObservable = input.loginTap.withLatestFrom(userAndPassword).flatMapLatest { (username, password) in
            return Observable.create { observer in
                observer.onNext((User(name: username, password: password), nil))
                return Disposables.create()
            }
        }
    }
}
