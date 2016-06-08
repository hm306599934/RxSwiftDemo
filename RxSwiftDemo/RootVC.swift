//
//  RootVC.swift
//  RxSwiftDemo
//
//  Created by Jimmy on 6/6/2016.
//  Copyright © 2016 Jimmy. All rights reserved.
//

import UIKit
import RxSwift

class RootVC: UITableViewController {
    
    var lalala = "fdds"
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //create
        _ = Observable<String>
            .create { (observerString) -> Disposable in
            print("Observable created")
            observerString.on(.Next("😊"))
            observerString.on(.Completed)
            
            return NopDisposable.instance
            }
            .subscribe {
                event in
                print(event)
                if let result = event.element {
                self.lalala += result
                }
            }
        //never
        _ = Observable<String>
            .never()
            .subscribe { _ in
                print("will never be printed")
            }
            .addDisposableTo(disposeBag)
        //empty
        _ = Observable<Int>
            .empty()
            .subscribe{event in
                print(event)
            }
            .addDisposableTo(disposeBag)
        //just
        _ = Observable.just("🔴")
            .subscribe { event in
                print(event)
            }
            .addDisposableTo(disposeBag)
        //of
        _ = Observable
            .of("🐶", "🐱", "🐭", "🐹")
            .subscribeNext { element in
                print(element)
            }
            .addDisposableTo(disposeBag)
        //toObservable
        _ = ["🐶", "🐱", "🐭", "🐹"]
        .toObservable()
        .subscribeNext{ print($0) }
        .addDisposableTo(disposeBag)
        //create
        let myJust = { (element: String) -> Observable<String> in
            return Observable.create { observer in
                observer.on(.Next(element))
                observer.on(.Completed)
                return NopDisposable.instance
            }
        }

        myJust("🎈")
            .subscribe{print($0)}
            .addDisposableTo(disposeBag)
        //range
        Observable
            .range(start: 1, count: 5)
            .subscribe{ print($0) }
            .addDisposableTo(disposeBag)
        //repeat
        Observable
            .repeatElement("🐱")
            .take(3)
            .subscribeNext {
                print($0)
            }
            .addDisposableTo(disposeBag)
        //generate
        Observable
            .generate(initialState: 0, condition: { $0 < 3 }, iterate: { $0 + 1 })
            .subscribeNext { print($0) }
            .addDisposableTo(disposeBag)
        //deferred
        var count = 1
        let deferredSequence = Observable<String>
                                .deferred{
                                    print("Creating \(count)")
                                    count += 1
                                    return Observable.create { observer in
                                        print("Emiting")
                                        observer.onNext("🐶")
                                        observer.onNext("🐱")
                                        observer.onNext("🐵")
                                        return NopDisposable.instance

                                    }
                                }
        deferredSequence
            .subscribeNext { print($0) }
            .addDisposableTo(disposeBag)
        deferredSequence
            .subscribeNext { print($0) }
            .addDisposableTo(disposeBag)
        //error
        Observable<Int>
            .error(Error.Test)
            .subscribe{ print($0) }
            .addDisposableTo(disposeBag)
        //doOn
        Observable
            .of("🍎", "🍐", "🍊", "🍋")
            .doOn { print("Intercepted:", $0) }
            .subscribeNext { print($0) }
            .addDisposableTo(disposeBag)
        
        //Publish Subject
        let subject = PublishSubject<String>()
        
        subject.addObserver("1")
        .addDisposableTo(disposeBag)
        subject.onNext("🐶")
        subject.onNext("🐱")
        
        subject.addObserver("2")
            .addDisposableTo(disposeBag)
        subject.onNext("💀")
        subject.onNext("🌂")
        
        print("*************************************************")
        //Replay Subject
        let subject1 = ReplaySubject<String>.create(bufferSize: 2)
        subject1.addObserver("a").addDisposableTo(disposeBag)
        subject1.onNext("🐶")
        subject1.onNext("🐱")
        
        subject1.addObserver("b").addDisposableTo(disposeBag)
        subject1.onNext("🅰️")
        subject1.onNext("🅱️")
        
        print("*************************************************")
        let subject2 = BehaviorSubject(value: "🔴")
        
        subject2.addObserver("z").addDisposableTo(disposeBag)
        subject2.onNext("🚗")
        subject2.onNext("🚕")
        
        subject2.addObserver("x").addDisposableTo(disposeBag)
        subject2.onNext("🛩")
        subject2.onNext("✈️")
        
        subject2.addObserver("c").addDisposableTo(disposeBag)
        subject2.onNext("🚦")
        subject2.onNext("🚥")
        
        print("*************************************************")
        //Start with:添加到sequence最前面发送
        Observable
            .of("🐶", "🐱", "🐭", "🐹")
            .startWith("3")
            .startWith("1", "2")
            .subscribeNext{ print($0) }
            .addDisposableTo(disposeBag)
        
        print("*************************************************")
        //Merge: 合并
        let subjectA = PublishSubject<String>()
        let subjectB = PublishSubject<String>()
        let subjectC = PublishSubject<String>()
        
        Observable
            .of(subjectA, subjectB, subjectC)
            .merge()
            .subscribeNext{ print($0) }
            .addDisposableTo(disposeBag)
        
        subjectA.onNext("6")
        subjectC.onNext("2")
        subjectB.onNext("3")
        subjectA.onNext("5")
        subjectC.onNext("4")
        subjectA.onNext("1")
        
        print("*************************************************")
        //zip:把多个subject组合成一个新的subject
        let stringSubject = PublishSubject<String>()
        let intSubject = PublishSubject<Int>()
        
        Observable.zip(stringSubject, intSubject) { stringElement, intElement in
                return "\(stringElement)...\(intElement)"
            }
            .subscribeNext{ print($0) }
            .addDisposableTo(disposeBag)
        stringSubject.onNext("🅰️")
        stringSubject.onNext("🅱️")
        
        intSubject.onNext(1)
        
        intSubject.onNext(2)
        intSubject.onNext(3)
        stringSubject.onNext("🆎")
        
        print("*************************************************")
        //SwitchLatest
        let subjectQ = BehaviorSubject(value: "⚽️")
        let subjectW = BehaviorSubject(value: "🍎")
        
        let variable = Variable(subjectQ)
        
        variable.asObservable()
            .switchLatest()
            .subscribeNext { print($0) }
            .addDisposableTo(disposeBag)
        
        subjectQ.onNext("🏈")
        subjectQ.onNext("🏀")
        
        variable.value = subjectW
        
        subjectW.onNext("⚾️")
        subjectW.onNext("🍐")
        
        print("*************************************************")
        //map: 计算新值
        Observable.of(1, 2, 3)
            .map{ $0 * $0 }
            .subscribeNext { print($0) }
            .addDisposableTo(disposeBag)
        
        print("*************************************************")
        //flatMap
        struct Player {
            var score: Variable<Int>
        }
        
        let 👦🏻 = Player(score: Variable(80))
        let 👧🏼 = Player(score: Variable(90))
        
        let player1 = Variable(👦🏻)
        let player2 = Variable(👦🏻)
        
        player1.asObservable()
            .flatMap { $0.score.asObservable() } // Change flatMap to flatMapLatest and observe change in printed output
            .subscribeNext { print("play1: \($0)") }
            .addDisposableTo(disposeBag)
        player2.asObservable()
            .flatMapLatest { $0.score.asObservable() } // Change flatMap to flatMapLatest and observe change in printed output
            .subscribeNext { print("play2: \($0)") }
            .addDisposableTo(disposeBag)
    
        👦🏻.score.value = 85
        player1.value = 👧🏼
        player2.value = 👧🏼
        👦🏻.score.value = 95 // Will be printed when using flatMap, but will not be printed when using flatMapLatest
        👧🏼.score.value = 100
        
        print("*************************************************")
        //scan
        Observable.of(10, 100, 1000)
            .scan(1) { aggregateValue, newValue in
                aggregateValue + newValue
            }
            .subscribeNext { print($0) }
            .addDisposableTo(disposeBag)
        
    }
}

extension ObservableType {
    
    /**
     Add observer with `id` and print each emitted event.
     - parameter id: an identifier for the subscription.
     */
    func addObserver(id: String) -> Disposable {
        return subscribe { print("Subscription:", id, "Event:", $0) }
    }
    
}
