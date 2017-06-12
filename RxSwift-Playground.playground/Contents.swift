//: Playground - noun: a place where people can play

import UIKit
import RxSwift

/*: Introduction
# What is Observables
Observables are the heart of Rx. You’re going to spend some time discussing what observables are, how to create them, and how to use them.
You’ll see “observable,” “observable sequence,” and “sequence” used interchangeably in Rx. And really, they’re all the same thing. You may even see an occasional “stream” thrown around from time to time, especially from developers that come to RxSwift from a different reactive programming environment. “Stream” also refers to the same thing, but in RxSwift, all the cool kids call it a sequence, not a stream. :]
*/

// Create Observable
example(of: "just, of, from") {
    // 1
    let one = 1
    let two = 2
    let three = 3
    // 2
    // Create an Observable with only one element and this way has to put an explicitly specify the type
    let observable: Observable<Int> = Observable<Int>.just(one)
    // Create an Observable with several elements and doesn explicitly specify the type
    let observable2 = Observable.of(one, two, three)
    // Create an Observable array
    let observable3 = Observable.of([one, two, three])
    // Create an Observable of individual type instances from a regular array of elements
    let observable4 = Observable.from([one, two, three])
}

// Subscribe Observable
example(of: "subscribe") {
    let one = 1
    let two = 2
    let three = 3
    let observable = Observable.of(one, two, three)
    /*: Print each event emitted by the observable .onNext(value), .onCompleted, .onError(error) */
    observable.subscribe { event in
        print(event)
    }

    // Event has an element property. It’s an optional value, because only .next events have an element
    observable.subscribe { event in
        if let element = event.element {
            print(element)
        }
    }

    // There’s a subscribe operator for each type of event an observable emits: next, error, and completed
    observable.subscribe(onNext: { element in
        print(element)
    })
}

// Dispose Observable
example(of: "dispose") {
    // To explicitly cancel a subscription, call dispose() on it. After you cancel the subscription, or dispose of it, the observable in the current example will stop emitting events
    let observable = Observable.of("A", "B", "C")
    let subscription = observable.subscribe { event in
        print(event)
    }

    subscription.dispose()
}

// DisposeBag Observable
example(of: "DisposeBag") {
    // Managing each subscription individually would be tedious, so RxSwift includes a DisposeBag type. A dispose bag holds disposables — typically added using
    // the .addDisposableTo() method — and will call dispose() on each one when the dispose bag is about to be deallocated
    let disposeBag = DisposeBag()
    Observable.of("A", "B", "C")
        .subscribe { // 3
            print($0) }
        .addDisposableTo(disposeBag) // 4
}

// Create Observable
example(of: "create") {
    let disposeBag = DisposeBag()
    // The create operator takes a single parameter named subscribe. Its job is to provide the implementation of calling subscribe on the observable. In other words, it defines all the events that will be emitted to subscribers
    Observable<String>.create { observer in
        // 1
        observer.onNext("1")
        // 2
        observer.onCompleted()
        // 3
        observer.onNext("?")
        // 4
        return Disposables.create()
        }.subscribe(
            onNext: { print($0) },
            onError: { print($0) },
            onCompleted: { print("Completed") },
            onDisposed: { print("Disposed") }
        )
        .addDisposableTo(disposeBag)
}
