//: Playground - Example about "Filtering Operators" in RxSwift

import UIKit
import RxSwift

enum MyError: Error {
    case anError
}

func print<T: CustomStringConvertible>(label: String, event: Event<T>) {
    print(label, event.element ?? event.error ?? event)
}

public func example(of description: String, action: () -> Void) {
    print("\n--- Example of:", description, "---")
    action()
}

example(of: "ignoreElements") {
    /* Introduction
    Ignore .next event elements. It will, however, allow through stop events, i.e., .completed or .error events.
     
     ignoreElements is useful when you only want to be notified when an observable has terminated, via a .completed or .error event.
     */

    let strikes = PublishSubject<String>()
    let disposeBag = DisposeBag()

    strikes
        .ignoreElements()
        .subscribe { _ in
            // this point only call on .completed or .error event
            print("You're out!")
        }
        .addDisposableTo(disposeBag)

    strikes.onNext("X")
    strikes.onNext("X")
    strikes.onNext("X")
    strikes.onCompleted()
}

example(of: "elementAt") {
    /* Introduction
     Takes the index of the element you want to receive, and it ignores everything else.
     */

    let strikes = PublishSubject<String>()
    let disposeBag = DisposeBag()

    strikes
        .elementAt(2)
        .subscribe(onNext: { element in
            print("Receive element: \(element)")
        })
        .addDisposableTo(disposeBag)
    strikes.onNext("number 0")
    strikes.onNext("number 1")
    strikes.onNext("number 2") // this onNext event will receive
}

example(of: "filter") {
    /*
     filter takes a predicate closure, which it applies to each element, allowing through only those elements for which the predicate resolves to true.
     */

    let disposeBag = DisposeBag()
    Observable.of(1, 2, 3, 4, 5, 6)
        .filter { integer in
            integer % 2 == 0
        }
        .subscribe(onNext: {
            print($0)
        })
        .addDisposableTo(disposeBag)
}

example(of: "skip") {
    /*
     It might be that you need to skip a certain number of elements.
     The skip operator allows you to ignore from the 1st to the number you pass as its parameter.
     */

    let disposeBag = DisposeBag()
    Observable.of("A", "B", "C", "D", "E", "F")
        .skip(3) // Ignore the first 3 elements
        .subscribe(onNext: {
            print($0) })
        .addDisposableTo(disposeBag)
}

example(of: "skipWhile") {
    /*
     skipWhile lets you include a predicate to determine what should be skipped. However, unlike filter, which will filter elements for the life of the subscription, skipWhile will only skip up until something is not skipped, and then it will let everything else through from that point on.
     
     returning true will cause the element to be skipped, and returning false will let it through.
     */

    let disposeBag = DisposeBag()
    Observable.of(2, 2, 3, 4, 4)
        .skipWhile { integer in
            integer % 2 == 0
        }
        .subscribe(onNext: {
            print($0)
        })
        .addDisposableTo(disposeBag)
}

example(of: "skipUntil") {
    /*
     skipUntil, which will keep skipping elements from the source observable (the one you’re subscribing to) until some other trigger observable emits
     
     Then it stops skipping and lets everything through from that point on.
     */

    let disposeBag = DisposeBag()
    let subject = PublishSubject<String>()
    let trigger = PublishSubject<String>()
    subject
        .skipUntil(trigger)
        .subscribe(onNext: {
            print($0) })
        .addDisposableTo(disposeBag)

    subject.onNext("A")
    subject.onNext("B")
    trigger.onNext("X") // When trigger emits, skipUntil will stop skipping.
    subject.onNext("C")
    subject.onNext("D")
}

example(of: "take") {
    /*
     Taking is the opposite of skipping. When you want to take elements, RxSwift has you covered.
     */

    let disposeBag = DisposeBag()
    Observable.of(1, 2, 3, 4, 5, 6)
        .take(3) // Take the first 3 elements
        .subscribe(onNext: {
            print($0) })
        .addDisposableTo(disposeBag)
}

example(of: "takeWhileWithIndex") {
    /*
     It takes while the predicate resolves to true, but also passes the index of the element so that you can reference or filter against that if you want to
     */

    let disposeBag = DisposeBag()
    Observable.of(2, 2, 4, 4, 6, 6)
        .takeWhileWithIndex { integer, index in
            integer % 2 == 0 && index < 3
        }
        .subscribe(onNext: {
            print($0)
        })
        .addDisposableTo(disposeBag)
}

example(of: "takeUntil") {
    /*
     Opposite with skipUntil, passing the trigger that will cause takeUntil to stop taking once it emits.
     */

    let disposeBag = DisposeBag()
    let subject = PublishSubject<String>()
    let trigger = PublishSubject<String>()

    subject
        .takeUntil(trigger)
        .subscribe(onNext: {
            print($0) })
        .addDisposableTo(disposeBag)

    subject.onNext("1")
    subject.onNext("2")
    trigger.onNext("X") // passing the trigger
    subject.onNext("3") // so 3 is not allowed through and nothing more is printed.
}

example(of: "distinctUntilChanged") {
    /*
     Use distinctUntilChanged to prevent sequential duplicates from getting through
     distinctUntilChanged only prevents contiguous duplicates
     */

    let disposeBag = DisposeBag()
    Observable.of("A", "A", "B", "B", "A")
        .distinctUntilChanged()
        .subscribe(onNext: {
            print($0) })
        .addDisposableTo(disposeBag)
}
