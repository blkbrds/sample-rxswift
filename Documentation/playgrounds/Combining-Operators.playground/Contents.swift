//: Playground - Example about "Combining" in RxSwift

import UIKit
import RxSwift

public func example(of description: String, action: () -> Void) {
    print("\n--- Example of:", description, "---")
    action()
}

example(of: "startWith") {
    /*
     prefixes an observable sequence with the given initial
     value. This value must be of the same type as the observable elements.
     */

    let numbers = Observable.of(2, 3, 4)
    let observable = numbers.startWith(1) // Create a sequence starting with the value 1, then continue with the original sequence of numbers.
    observable.subscribe(onNext: { value in
        print(value)
    })
}

example(of: "Observable.concat") {
    /*
     chains two sequences.
     */

    let first = Observable.of(1, 2, 3)
    let second = Observable.of(4, 5, 6)
    let observable = Observable.concat([first, second]) // Observable.concat(_:) static function takes an ordered collection of observables
    observable.subscribe(onNext: { value in
        print(value)
    })
}

example(of: "concat") {
    let germanCities = Observable.of("Berlin", "Munich", "Frankfurt")
    let spanishCities = Observable.of("Madrid", "Barcelona", "Valencia")
    let observable = germanCities.concat(spanishCities)
    observable.subscribe(onNext: { value in
        print(value)
    })
}

example(of: "concat one element") {
    let numbers = Observable.of(2, 3, 4)
    let observable = Observable
        .just(1)
        .concat(numbers)
    observable.subscribe(onNext: { value in
        print(value)
    })
}

example(of: "merge") {
    /*
     RxSwift offers several ways to combine sequences
     */

    let left = PublishSubject<String>()
    let right = PublishSubject<String>()
    let source = Observable.of(left.asObservable(), right.asObservable())
    let observable = source.merge() // create a merge observable from the two subject
    /*
     Notice that merge() takes a source observable, which itself emits observables sequences of the element type. This means that you could send a lot of sequences for merge() to subscribe to!
     */

    let disposable = observable.subscribe(onNext: { value in
        print(value)
    })
    var leftValues = ["Berlin", "Munich", "Frankfurt"]
    var rightValues = ["Madrid", "Barcelona", "Valencia"]

    left.onNext("Left:  " + leftValues.removeFirst())
    right.onNext("Right: " + rightValues.removeFirst())
    left.onNext("Left:  " + leftValues.removeFirst())
    right.onNext("Right: " + rightValues.removeFirst())
    right.onNext("Right: " + rightValues.removeFirst())
    left.onNext("Left:  " + leftValues.removeFirst())

    disposable.dispose()

    /*
     How merge() completes?. The rules are well-defined:
     • merge() completes after its source sequence completes and all inner sequences have completed.
     • The order in which the inner sequences complete is irrelevant.
     • If any of the sequences emit an error, the merge() observable immediately relays the error, then terminates.
     
     To limit the number of sequences subscribed to at once, you can use merge(maxConcurrent:). This variant keeps subscribing to incoming sequences until it reaches the maxConcurrent limit. After that, it puts incoming observables in a queue. It will subscribe to them in order, as soon as one of current sequences completes. You could use it in scenarios such as making a lot of network requests to limit the number of concurrent outgoing connections.
     */
}

example(of: "combineLatest") {
    /*
     Every time one of the inner (combined) sequences emits a value, it calls a closure you provide. You receive the last value from each of the inner sequences. This has many concrete applications, such as observing several text fields at once and combining their value, watching the status of multiple sources, and so on
     
     Sequences don’t need to have the same element type. You can combine sequences of heterogeneous types (example combine "String" type and Int "type"). It is (combineLatest) the only core operator that permits this.

     Note: Remember that combineLatest(_:_:resultSelector:) waits for all its observables to emit one element before starting to call your closure. It’s a frequent source of confusion and a good opportunity to use the startWith(_:) operator to provide an initial value for the sequences, which could take time to update.
     */

    let left = PublishSubject<String>()
    let right = PublishSubject<String>()

    let observable = Observable.combineLatest(left, right, resultSelector: {
        lastLeft, lastRight in
        "\(lastLeft) && \(lastRight)" // create value return for subscribes
    })

    let disposable = observable.subscribe(onNext: { value in
        print(value)
    })

    left.onNext("left-Hello")
    right.onNext("right-world")
    left.onNext("left-RxSwift")
    right.onNext("right-combine")
    right.onNext("right-Latest")
    left.onNext("left-Ok")

    disposable.dispose()

    /*
     A common pattern is to combine values to a tuple then pass them down the chain. For example, you’ll often want to combine values and then call filter(_:) on them like so:
            let observable = Observable.combineLatest(left, right) { ($0, $1) }
                                                    .filter { !$0.0.isEmpty }
     
     Or if you want that code to be a bit more readable (but also just a tad longer to write):
     let observable1 = Observable.combineLatest(left, right) { (greeting: $0, noun: $1) }
                                                    .filter { !$0.greeting.isEmpty }
     */
}

example(of: "zip") {
    /*
     Then create a zipped observable of both sources
     Here’s what zip(_:_:resultSelector:) did for you: 
     • Subscribed to the observables you provided.
     • Waited for each to emit a new value.
     • Called your closure with both new values
     */

    enum Weather {
        case cloudy
        case sunny }
    let left: Observable<Weather> = Observable.of(.sunny, .cloudy, .cloudy, .sunny)
    let right = Observable.of("Lisbon", "Copenhagen", "London", "Madrid", "Vienna")
    let observable = Observable.zip(left, right) { weather, city in
        return "It's \(weather) in \(city)"
    }
    observable.subscribe(onNext: { value in
        print(value)
    })

    /* NOTE:
     Did you notice how Vienna didn’t show up in the output? Why is that?
     
     The explanation lies in the way zip operators work. They wait until each of the inner observables emits a new value. If one of them completes, zip completes as well. It doesn’t wait until all of the inner observables are done! This is called indexed sequencing, which is a way to walk though sequences in lockstep.
     */
}

/* *--- Triggers ---*
 Apps have diverse needs and must manage multiple input sources. You’ll often need to accept input from several observables at once. Some will simply trigger actions in your code, while others will provide data. RxSwift has you covered with powerful operators that will make your life easier
 */

example(of: "withLatestFrom") {
    //This example simulates a text field and a button
    /*
     Create two subjects simulating button presses and textfield input. Sincethe
     button carries no real data, you can use Void as an element type.
     */
    let button = PublishSubject<Void>()
    let textField = PublishSubject<String>()


    /*
     When button emits a value, ignore it but instead emit the latest value received
     from the simulated text field.
     */
    let observable = button.withLatestFrom(textField)
    //let observable = textField.sample(button)
    let disposable = observable.subscribe(onNext: { value in
        print(value)
    })

    textField.onNext("Par")
    textField.onNext("Pari")
    textField.onNext("Paris")
    button.onNext()
    button.onNext()

    /*
     A close relative to withLatestFrom(_:) is the sample(_:) operator.

     each time the trigger observable (is button in this example) emits a value, sample(_:) emits the latest value from the “other” observable, but only if it arrived since the last “tick”. If no new data arrived, sample(_:) won’t emit anything.
     
     Try it in the playground. Replace withLatestFrom(_:) with sample(_:):
            let observable = textField.sample(button)
     
     Notice that "Paris" now prints only once! This is because no new value was emitted by the text field between your two fake button presses. You could have achieved the same behavior by adding a distinctUntilChanged() to the withLatestFrom(_:)
     */

    /*
     Note: Don’t forget that withLatestFrom(_:) takes the data observable as a parameter, while sample(_:) takes the trigger observable as a parameter. This can easily be a source of mistakes — so be careful!
     */
}

/* *--- Switches ---*
 RxSwift comes with two main so-called “switching” operators: amb(_:) ("amb" as in "ambiguous") and switchLatest(). They both allow you to produce an observable sequence by switching between the events of the combined or source sequences. This allows you to decide which sequence's events will the subscriber receive at runtime.
 */

example(of: "amb") {
    /*
     The amb(_:) operator subscribes to left and right observables. 

     "It waits for any of them (left or right observables) to emit an element, then unsubscribes from the other one. After that, it only relays elements from the first active observable".

     It really does draw its name from the term ambiguous: at first, you don’t know which sequence you’re interested in, and want to decide only when one fires.
     
     This operator is often overlooked. It has a few select practical applications, like
     connecting to redundant servers and sticking with the one that responds first.
     */

    let left = PublishSubject<String>()
    let right = PublishSubject<String>()
    let observable = left.amb(right)
    let disposable = observable.subscribe(onNext: { value in
        print(value)
    })

    left.onNext("Left first active") // "left observable" is "first active", so "right observable" will be "unsubscribes as a ambiguous", result is only print emits of left
    right.onNext("Right first active")
    left.onNext("Left 1")
    left.onNext("Left 2")
    right.onNext("Right 1")
    right.onNext("Right 2")
    left.onNext("Left 3")
    disposable.dispose()
}

example(of: "switchLatest") {
    /*
     Your subscription only prints items from the latest sequence pushed to the source observable.
     */

    let one = PublishSubject<String>()
    let two = PublishSubject<String>()
    let three = PublishSubject<String>()
    let source = PublishSubject<Observable<String>>()

    let observable = source.switchLatest()
    let disposable = observable.subscribe(onNext: { value in
        print(value)
    })

    source.onNext(one)
    one.onNext("one: 1")
    two.onNext("two: 1")
    source.onNext(two)
    two.onNext("two: 2")
    one.onNext("one: 2")
    source.onNext(three)
    two.onNext("two: 3")
    one.onNext("one: 4")
    three.onNext("three: 1")
    source.onNext(one)
    one.onNext("one: 5")
    disposable.dispose()
}

example(of: "reduce") {
    /*
     Reduce is much like what you’d do with Swift collections, but with observable sequences.

    Note: reduce(_:_:) produces its summary (accumulated) value only when the source observable completes. "Applying this operator to sequences that never complete won’t emit anything". This is a frequent source of confusion and hidden problems.
     */

    let source = Observable.of(1, 3, 5, 7, 9)

    let observable = source.reduce(0, accumulator: +)
    observable.subscribe(onNext: { value in
        print(value)
    })

    //To get a grasp on how reduce(_:_:) above works, replace the observable creation above with the following code:

    /*
     The operator “accumulates” a summary value. It starts with the initial value you provide (in this example, you start with 0). Each time the source observable emits an item, reduce(_:_:) calls your closure to produce a new summary. When the source observable completes, reduce(_:_:) emits the summary value, then completes.
     */
    let disposeBag = DisposeBag()
    let numberObservable = PublishSubject<Int>()
    let observable1 = numberObservable.reduce(0, accumulator: { summary, newValue in
        // Each time numberObservable emits an item, this closure will call to produce a new summary
        return summary + newValue
    })
    observable1.subscribe(onNext: { (value) in
        // When the numberObservable completes (call number.onCompleted()), this closure will call with value is (0 + 1 + 2 + 3 + 5)
        print(value)
    }).addDisposableTo(disposeBag)
    numberObservable.onNext(1)
    numberObservable.onNext(2)
    numberObservable.onNext(3)
    numberObservable.onNext(5)
    numberObservable.onCompleted() // this emit will be call subscribe of observable1 and print log 11
}

example(of: "scan") {
    /*
     scan sequence with { acc, value -> Int in
                                return acc + value }

     Each time the source observable emits an element, scan(_:accumulator:) invokes your closure. It passes the running value along with the new element, and the closure returns the new accumulated value. Like reduce(_:_:), the resulting observable type is the closure return type.
     */
    let source = Observable.of(1, 3, 5, 7, 9)
    let observable = source.scan(0, accumulator: +)
    observable.subscribe(onNext: { value in
        print(value)
    })
}
