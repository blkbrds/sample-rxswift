//: Playground - Example about "Transforming" in RxSwift

import UIKit
import RxSwift

public func example(of description: String, action: () -> Void) {
    print("\n--- Example of:", description, "---")
    action()
}

example(of: "toArray") {
    /*
     toArray will convert an observable sequence of elements into an array of those elements, and emit a .next event containing that array to subscribers.
     */

    let disposeBag = DisposeBag()
    Observable.of("A", "B", "C")
        .toArray()
        .subscribe(onNext: {
            print($0) })
        .addDisposableTo(disposeBag)
}

example(of: "map") {
    /*
     RxSwift’s map operator works just like Swift’s standard map, except it operates on observables
     */

    let disposeBag = DisposeBag()
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut

    Observable<NSNumber>.of(123, 4, 56)
        .map {
            formatter.string(from: $0) ?? ""
        }
        .subscribe(onNext: {
            print($0)
        })
        .addDisposableTo(disposeBag)
}

example(of: "mapWithIndex") {
    /*
     mapWithIndex also passes the element’s index to its closure.
     */

    let disposeBag = DisposeBag()
    Observable.of(1, 2, 3, 4, 5, 6)
        .mapWithIndex { integer, index in
            index > 2 ? integer * 2 : integer
        }
        .subscribe(onNext: {
            print($0)
        })
        .addDisposableTo(disposeBag)
}

struct Student {
    var score: Variable<Int>
}

example(of: "flatMap") {
    /*
     Projects each element of an observable sequence to an observable sequence and "merges the resulting observable sequences" into one observable sequence.
     */

    let disposeBag = DisposeBag()
    let ryan = Student(score: Variable(80))
    let charlotte = Student(score: Variable(90))
    let student = PublishSubject<Student>()

    student.asObservable()
        .flatMap {
            $0.score.asObservable()
        }
        .subscribe(onNext: {
            print($0)
        })
        .addDisposableTo(disposeBag)

    student.onNext(ryan)
    ryan.score.value = 85
    student.onNext(charlotte)
    ryan.score.value = 95 // ryan’s new score is printed.
    charlotte.score.value = 100 // charlotte's new score is printed out.
}

example(of: "flatMapLatest") {
    /*
     switchLatest will produce values from the most recent observable, and unsubscribe from the previous observable.

     Projects each element of an observable sequence into a new sequence of observable sequences 
     and then transforms an observable sequence of observable sequences into an observable 
     sequence "producing values only from the most recent observable sequence".
     */

    let disposeBag = DisposeBag()
    let ryan = Student(score: Variable(80))
    let charlotte = Student(score: Variable(90))
    let student = PublishSubject<Student>()

    student.asObservable()
        .flatMapLatest {
            $0.score.asObservable()
        }
        .subscribe(onNext: {
            print($0)
        })
        .addDisposableTo(disposeBag)

    student.onNext(ryan)
    ryan.score.value = 85
    student.onNext(charlotte)
    ryan.score.value = 95 // will have no printed
    /*
     Changing ryan’s score here (95) will have no effect.It will not be printed out.This is because flatMapLatest has already switched to the latest observable, for charlotte.
     */

    charlotte.score.value = 100 // charlotte's new score is printed
}
