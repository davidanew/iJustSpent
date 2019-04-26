//import UIKit
import Foundation
import RxSwift
import RxCocoa




//print("hello")

/*
let primaryPublishSubject = PublishSubject<Int>()
let secondaryPublishSubject = PublishSubject<Int>()

primaryPublishSubject.flatMap{_ in return secondaryPublishSubject}.subscribe(onNext : {print ($0)})

primaryPublishSubject.onNext(1)
secondaryPublishSubject.onNext(2)
primaryPublishSubject.onNext(3)
*/

/*
let primaryBehaviorSubject = BehaviorSubject<Int>(value: 10)
let secondaryBehaviorSubject = BehaviorSubject<Int>(value: 1)

primaryBehaviorSubject.flatMapLatest{ primary in
    return secondaryBehaviorSubject.map{secondary in
        secondary * primary}
    }.subscribe(onNext : {print ($0)})

primaryBehaviorSubject.onNext(100)
secondaryBehaviorSubject.onNext(2)
secondaryBehaviorSubject.onNext(3)

primaryBehaviorSubject.onNext(1000)
*/

/*
let obs : Observable<Int> = Observable.empty()

let theSubject = PublishSubject<Int>()

//obs.subscribe(onNext: {_ in print ("hello")})
theSubject.subscribe(onNext: {print ($0)})

Observable.of(2,2).bind(to: theSubject)
*/

[1,2].map{print ($0)}








