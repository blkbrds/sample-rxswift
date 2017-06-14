# RxSwift examples
## About RxSwift
* **RxSwift**: ```Reactive Programming in Swift```, which is a part of the Functional Reactive Programming (FRP) design pattern — where views react to changes to data. **FRP** is not **MVC**. 
``` 
 Reactive Programming, which focuses on asynchronous data streams, which you can listen to and react 
 accordingly. To learn more, check out this great introduction.
```
```
 Functional Programming, which emphasizes calculations via mathematical-style functions, immutability 
 and expressiveness, and minimizes the use of variables and state.
```
* **RxSwift** is a library for composing asynchronous and event-based code by using observable sequences and functional style operators, allowing for parameterized execution via schedulers.
* **RxSwift** in its essence, simplifies developing asynchronous programs by allowing your code to react to new data and process it in sequential, isolated manner.

## Usage
* Bindings
```swift
 Observable.combineLatest(firstName.rx.text, lastName.rx.text) { $0 + " " + $1 }
     .map { "Full name: \($0)" }
     .bind(to: fullnameLabel.rx.text)
```

This also works with `UITableView` and `UICollectionView`

```swift
 viewModel
     .rows
     .bind(to: resultsTableView.rx.items(cellIdentifier: "MyCell", cellType: MyCustomCell.self)) { (_, viewModel, cell) in
        cell.title = viewModel.title
        cell.url = viewModel.url
    }
    .disposed(by: disposeBag)
```

* A typical example is an autocomplete search box

```swift
searchTextField.rx.text
    .throttle(0.3, scheduler: MainScheduler.instance)
    .distinctUntilChanged()
    .flatMapLatest { query in
        API.getSearchResults(query)
            .retry(3)
            .startWith([]) // clears results on new search term
            .catchErrorJustReturn([])
    }
    .subscribe(onNext: { results in
      // bind to ui
    })
    .disposed(by: disposeBag)
```

* Making HTTP requests
```swift
let responseJSON = URLSession.shared.rx.json(request: urlRequest)

// no requests will be performed up to this point
// `responseJSON` is just a description how to fetch the response

let cancelRequest = responseJSON
    // this will fire the request
    .subscribe(onNext: { json in
        print(json)
    })

Thread.sleep(forTimeInterval: 3.0)

// if you want to cancel request after 3 seconds have passed just call
cancelRequest.dispose()
```

## Tutorials
[Documentation](https://github.com/blkbrds/sample-rxswift/edit/master/Documentation) folder contains theories and playgrounds to understand about RxSwift

## Installation
Run ```./scripts/install``` in scripts folder to setup and install pod.

## Examples
* Calculator
* Validate user name and password
* Search bar
* Fetch Data from Server
* MVVM with RxSwift

## References
* [Github RxSwift](https://github.com/ReactiveX/RxSwift)
* [RxSwift Getting Started](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/GettingStarted.md)
