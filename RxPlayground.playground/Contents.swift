//: Playground - noun: a place where people can play

import UIKit
import RxSwift

var str = "Hello, playground"

// 1
let one = 1
let two = 2
let three = 3
// 2
let observable: Observable<Int> = Observable<Int>.just(one)

let observable2 = Observable.of(one, two, three)

let observable3 = Observable.of([one, two, three])

let observable4 = Observable.from([one, two, three])

let subcribe = observable2.subscribe(
    onNext: { element in
        print(element)
    }, onCompleted: {
        print("Completed")
    })

let disposeBag = DisposeBag()
// 2
Observable.of("A", "B", "C")
    .subscribe { // 3
        print($0) }
    .addDisposableTo(disposeBag) // 4