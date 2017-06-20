//: Playground - Example about Subjects in RxSwift

import UIKit
import RxSwift

enum MyError: Error {
    case anError
}

func print<T: CustomStringConvertible>(label: String, event: Event<T>) {
    print(label, event.element ?? event.error ?? event)
}

public func example(of description: String, action: () -> Void) {
    print("\n---Example of:", description, "---")
    action()
}

example(of: "PublishSubject") {
    /* Introduction
     PublishSubject starts empty and only emits new elements to subscribers.
     */

    let subject = PublishSubject<String>()
    subject.onNext("Is anyone listening?")
    // nothing is printed out yet at this point, because there are no observers
    
    let subscriptionOne = subject
        .subscribe(onNext: { string in
            print("subscribe 1: " + string)
        })
    subject.on(.next("1"))
    subject.onNext("2")

    print("--- subscribe for subscriptionTwo ---")
    let subscriptionTwo = subject
        .subscribe { event in
            print(label: "subscribe 2:", event: event)
    }
    /*
     At this point, subscriptionTwo doesn’t print anything out yet because it subscribed after the (1) and (2) were emitted
     */

    subject.onNext("3")

    subscriptionOne.dispose()
    subject.onNext("4")
    /*
     The value 4 is only printed for subscription 2), because subscriptionOne was disposed.
     */

    /*
     When a publish subject receives a .completed or .error event, aka a stop event, it will emit that stop event to new subscribers and it will no longer emit .next events. However, it will re-emit its stop event to future subscribers
     */
    subject.onCompleted()

    /*
     Add another element onto the subject.This won't be emitted and printed,
     though, "because the subject has already terminated"
     */
    print("--- Add another element onto the subject after subject completed ---")
    subject.onNext("5") // This won't be emitted and printed
    subscriptionTwo.dispose()

    /*
     Create a new subscription to the subject,this time adding it to a dispose bag
     */
    print("--- Create a new subscription after subject completed ---")
    let disposeBag = DisposeBag()
    subject
        .subscribe {
            print(label: "subscribe 3:", event: $0)
        }
        .addDisposableTo(disposeBag)
    print("--- subject.onNext ---")
    subject.onNext("?") // This won't be emitted and printed
}

// *------------------ BehaviorSubject -----------------------------*
example(of: "BehaviorSubject") {
    /* Introduction
     Behavior subjects work similarly to publish subjects, except they will replay the latest .next event to new subscribers.

     Since BehaviorSubject always emits the latest element, you can't create one without providing a default initial value. If you can't provide a default initial value at creation time, that probably means you need to use a PublishSubject instead.
     */

    // Create new BehaviorSubject instance. Its initializer takes an initial value.
    let subject = BehaviorSubject(value: "Initial value")
    let disposeBag = DisposeBag()

    print("--- subscribe for subscription 1 ---")
    subject
        .subscribe {
            print(label: "subscribe 1:", event: $0) // subscribe will immediately receive "initial value"
        }
        .addDisposableTo(disposeBag)

    subject.onNext("X") // The X is printed, because now it’s the latest element when the subscription is made.

    subject.onError(MyError.anError) // Add an error event onto the subject

    // Create a new subscription to the subject.
    print("--- subscribe for subscription 2 ---")
    subject
        .subscribe {
            print(label: "subscribe 2:", event: $0) // will also print error event
        }
        .addDisposableTo(disposeBag)
}

// *------------------ ReplaySubject -----------------------------*
example(of: "ReplaySubject") {
    /* Introduction
     Replay subjects will temporarily cache, or buffer, the latest elements it emits, up to a specified size of your choosing. It will then replay that buffer to new subscribers.
     */
    
    // create a new replaysubject with a buffer size of 2
    let subject = ReplaySubject<String>.create(bufferSize: 2)
    let disposeBag = DisposeBag()

    subject.onNext("1")
    subject.onNext("2")
    subject.onNext("3")

    print("--- subscribe for subscription 1 and 2 ---")
    subject
        .subscribe {
            print(label: "subscribe 1:", event: $0)
        }
        .addDisposableTo(disposeBag)
    subject
        .subscribe {
            print(label: "subscribe 2:", event: $0)
        }
        .addDisposableTo(disposeBag)
    /*
     The latest two elements ("2" and "3") are replayed to both subscribers. ("1") never gets emitted, because ("2") and ("3") were added onto the replay subject with a buffer size of 2 before anything subscribed to it.
     */

    print("--- subject.onNext ---")
    subject.onNext("4")

    print("--- subscribe for subscription 3 ---")
    subject
        .subscribe {
            print(label: "subscribe 3:", event: $0)
        }
        .addDisposableTo(disposeBag)
    // new third subscriber will get the last two buffered elements ("3" and "4") replayed to it.

    print("--- subject.onError ---")
    subject.onError(MyError.anError)

    print("--- subscribe for subscription 4 ---")
    subject
        .subscribe {
            print(label: "subscribe 4:", event: $0)
        }
        .addDisposableTo(disposeBag)
    /*
    subscription 4 will last two buffered elements ("3" and "4") and one event error
     */

    /*
    If you want new subscribers will only receive an error event, by call explicitly calling dispose "subject.dispose()" indicating that the subject was already disposed.
     */
}

// *------------------ Variable -----------------------------*
example(of: "Variable") {
    /* Introduction
     a Variable wraps a BehaviorSubject and stores its current value as state. You can access that current value via its value property, and, unlike other subjects and observables in general, you also use that value property to set a new element onto a variable. In other words, you don’t use onNext(_:).
     
     Because it wraps a behavior subject, a variable is created with an initial value, and it will replay its latest or initial value to new subscribers. In order to access a variable’s underlying behavior subject, you call asObservable() on it.
     
     Also unique to Variable, as compared to other subjects, is that it is guaranteed not to emit an error. So although you can listen for .error events in a subscription to a variable, you cannot add an .error event onto a variable. A variable will also automatically complete when it’s about to be deallocated, so you do not (and in fact, can’t) manually add a .completed event to it.
     */

    let disposeBag = DisposeBag()

    var variable = Variable("Initial value") // Create a variable type as Variable<String> with an "initial value"

    variable.value = "New initial value" // Add a new element onto the variable.

    // Subscribe to the variable, first by calling asObservable() to access its underlying behavior subject.
    print("--- subscribe for subscription 1 ---")
    variable.asObservable()
        .subscribe {
            print(label: "subscribe 1:", event: $0)
        }
        .addDisposableTo(disposeBag)

    print("--- change value to 1 ---")
    variable.value = "1" // Add a new element onto the variable.

    // Create a new Subscribe to the variable
    print("--- subscribe for subscription 2 ---")
    variable.asObservable()
        .subscribe {
            print(label: "subscribe 2:", event: $0)
        }
        .addDisposableTo(disposeBag)

    print("--- change value to 2 ---")
    variable.value = "2" // Add another new element onto the variable

    /*
     There is no way to add an .error or .completed event onto a variable. Any attempts to do so will generate compiler errors.
     
     // These will all generate errors
     variable.value.onError(MyError.anError)
     variable.asObservable().onError(MyError.anError)
     variable.value = MyError.anError
     variable.value.onCompleted()
     variable.asObservable().onCompleted()
     */
}
